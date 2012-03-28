# encoding: utf-8
class PercentsController < ApplicationController
  include PercentsHelper
  #人人测试应用访问路径 http://apps.renren.com/passcet   ,注: localhost:3000启动项目

  @@renren_client_id = "185877"
  @@renren_secret_key = "a45567526a374dcb9c06412cb3c93d74"

  #人人应用，嵌入首页
  def renren
    @client_id = @@renren_client_id
    render :layout=>false
  end

  #人人oauth2,回调地址中的"#"，替换为"?"
  def renren_url_generate
    render :inline=>"<script type='text/javascript'>var p = window.location.href.split('#');var pr = p.length>1 ? p[1] : '';window.location.href = '/percents/check?'+pr;</script>"
  end

  #人人登录之后的回调页面，取得用户信息
  def check
    access_token = params["access_token"]
    cookies[:access_token] = access_token
    user_info = renren_get_user(access_token,@@renren_secret_key)
    render :inline=>"#{user_info}"
  end
  
  def create
    total_score = params["ability"].to_i + params["heart"].to_i + params["attitude"].to_i
    @message = Constant::SCORE_LEVEL[total_score]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def send_message
    @return_message = ""
    if params[:web] == "sina"
      ret = sina_send_message(cookies[:access_token], params[:mesage])
      @return_message = "微博发送失败，请重新尝试" if ret["error_code"]
    elsif params[:web] == "renren"
      ret = renren_send_message(cookies[:access_token], params[:mesage], @@renren_secret_key)
      @return_message = "分享失败，请重新尝试" if ret[:error_code]    
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  #发表微博，并转发到空间
  def add_idol
#    client_ip=request.headers["HTTP_X_REAL_IP"]
    total_score = params["ability"].to_i + params["heart"].to_i + params["attitude"].to_i
    @message = Constant::SCORE_LEVEL[total_score]
    pars={
      :appid=>Constant::APPID,:openid=>params[:openid].to_s,:openkey=>params[:openkey].to_s,:pf=>"",:content=>"111",:clientip=>"127.0.0.1"
    }
    url="http://119.147.19.43/v3/t/add_t"
    url_params=pars.sort.map{|k,v|"#{k}=#{v}"}.join("& ")
#    url="openid=08B8273CACFBE0D9F57CAB4E7D8AAAA0& openkey=9999999917C28878F66F28E7F16B7F89E7E752D589B8B261& appid=1& sig=9999b41ad0b688530bb1b21c5957391c& pf=tapp& format=json& userip=112.90.139.30& content=aaaa& clientip=129.10.20.11& jing=+110.5& wei=+23.4"
    uri=URI.parse("#{url}?#{url_params}&sig=#{signature_params(Constant::APPID,url_params,url,"POST",Constant::APPKEY)}")
    p "#{url}?#{url_params}&sig=#{signature_params(Constant::APPID,url_params,url,"POST",Constant::APPKEY)}"
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({:content=>"111",:clientip=>"127.0.0.1"})
    respond=http.request(request)
    p respond.body
    respond_to do |format|
      format.json{
        render :json=>"成功"
      }
    end
  end


end
