# encoding: utf-8
class ImagesController < ApplicationController
  require 'rubygems'
  require 'RMagick'
  require 'net/http'
  require "uri"
  require 'openssl'
  require 'net/http/post/multipart'
  include PercentsHelper
  respond_to :html, :xml, :json, :js

  def create
    if params[:current_type].to_i==4
      ren_screct = "15fcd9c3961642c38ece5e48c655adcf"
      caption="亲，我的【英语四级过关几率】竟然是#{params[:score]}，你的呢 http://apps.renren.com/pass_cet"
    else
      ren_screct = "7ca4354ed5ae498bb35c896da95704a6"
      caption="亲，我的【英语六级过关几率】竟然是#{params[:score]}，你的呢 http://apps.renren.com/check_cet"
    end
    rmagick = params[:score]
    bg = Magick::ImageList.new("#{Rails.root}/public/#{params[:current_type]}.jpg")
    i = Magick::ImageList.new
    i.new_image(800, 628) { self.background_color = 'transparent' }
    primitives = Magick::Draw.new
    primitives.annotate i, 0, 0, 20, 10, rmagick do
      #self.font="#{Rails.root}/public/simhei.ttf"
      self.pointsize = 160
      self.fill = "#F6E7BC"
      self.stroke = "white"
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
    end
    begin
      result = bg.composite_layers(i)
      result.delay = 10
      file_url="#{Rails.root}/public/composite_layers.gif"
      result.write(file_url)
      back_info=renren_send_pic(cookies[:access_token],file_url,ren_screct,caption)
    rescue NotImplementedError
    end
    respond_to do |format|
      format.json {
        render :json=>{:message=>back_info}
      }
    end
  end

  #人人网签名
  def sig_renren(query,api_serect)
    str=""
    query.sort.each{|key,value|str<<"#{key}=#{value}"}
    str << api_serect
    query[:sig]=Digest::MD5.hexdigest(str)
    return query
  end

  # 带图片微博
  def renren_send_pic(access_token,img_url,api_serect,caption)
    query={:access_token=>access_token,:format => 'JSON', :method => 'photos.upload',:v => '1.0',:caption=>caption}
    url = URI.parse("http://api.renren.com/restserver.do")
    File.open(img_url) do |jpg|
      req = Net::HTTP::Post::Multipart.new url.path,sig_renren(query,api_serect).merge!("upload" => UploadIO.new(jpg, "image/jpeg", "image.jpg"))
      http = Net::HTTP.new(url.host, url.port)
      info= http.request(req).body
      return info
    end
  end
  
end
