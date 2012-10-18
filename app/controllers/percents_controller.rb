# encoding: utf-8
class PercentsController < ApplicationController
  include PercentsHelper
  #人人测试应用访问路径 http://apps.renren.com/passcet   ,注: localhost:3000启动项目

  @@renren_client_id = "189847"
  @@renren_secret_key = "f3556085271d4590a9adab188fb2db65"

  #人人应用，嵌入首页
  def renren
    cookies.delete(:six) unless cookies[:six].nil?
    @client_id = @@renren_client_id
    render :layout=>false
  end

  #人人oauth2,回调地址中的"#"，替换为"?"
  def renren_url_generate
    render :inline=>"<script type='text/javascript'>var p = window.location.href.split('#');var pr = p.length>1 ? p[1] : '';window.location.href = '/percents/check?web=renren&'+pr;</script>"
  end

  #人人登录之后的回调页面,记录access_token,跳转到测试页
  def check
    access_token = params["access_token"]
    web = params["web"]
    cookies[:access_token] = access_token if access_token
    puts " #{web}  --  #{cookies[:access_token]}  "
    redirect_to "/percents?web=#{web}"
  end

  @@renren6_client_id = "196453"
  @@renren6_secret_key = "a796bc292ddf457c84f097fd7ac6f579"

  #人人六级应用
  def renren6
    cookies[:six] ={:value =>"6", :path => "/", :secure  => false}
    @client_id = @@renren6_client_id
    render :layout=>false
  end


  @@renren8_client_id = "196777"
  @@renren8_secret_key = "79fb9cf508dd4751a1c3260ab57b43be"

  #人人研究生应用
  def renren8
    cookies[:six] ={:value =>"8", :path => "/", :secure  => false}
    @client_id = @@renren8_client_id
    render :layout=>false
  end

  @@sina_app_key = "668934093"
  @@sina_app_secret = "bce8d1dcd35f257d1b46fd36e99f50c8"

  def sina
    cookies.delete(:six) unless cookies[:six].nil?
    @app_key = @@sina_app_key
    @app_secret = @@sina_app_secret
    signed_request = params[:signed_request]
    if signed_request
      list = signed_request.split(".")
      encoded_sig,pay_load =list[0],list[1]
      base_str = Base64.decode64(pay_load)
      base_str = base_str.split(",\"referer\"")[0]
      base_str = base_str[-1]=="}" ? base_str : "#{base_str}}"
      @data = JSON (base_str)
      @login = false
      if @data["user_id"] && @data["oauth_token"]
        @login = true
        cookies[:access_token] = @data["oauth_token"]
      end
    end
    render :layout=>false
  end
  

  #新浪关注
  def guanzhu
    ret = sina_guanzhu(cookies[:access_token],Constant::WEIBO_ID)
    respond_to do |format|
      format.json {
        render :json=>""
      }
    end
  end

  def send_message
    @return_message = ""
    @web = ""
    if params[:web] == "sina"
      @web = "sina"
      ret = sina_send_message(cookies[:access_token], params[:message])
      @return_message = "微博发送失败，请重新尝试" if ret["error_code"]
    elsif params[:web] == "renren"
      @web = "renren"
      @type = params[:type]
      @secret_key = @type == "8" ? @@renren8_secret_key : (@type=="6" ? @@renren6_secret_key : @@renren_secret_key)
      ret = renren_send_message(cookies[:access_token], params[:message], @secret_key , @type)
      @return_message = "分享失败，请重新尝试" if ret[:error_code]    
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  def add_idol
    pars={
      :appid=>Constant::APPID,:openid=>params[:openid].to_s,:openkey=>params[:openkey].to_s,:pf=>"qzone",:name=>"gankao2011"
    }
    url="http://119.147.19.43/v3/relation/add_idol"
    url_params=pars.sort.map{|k,v|"#{k}=#{v}"}.join("&")
    uri=URI.parse("#{url}?#{url_params}&sig=#{signature_params(Constant::APPID,url_params,url,"POST",Constant::APPKEY)}")
    p "#{url}?#{url_params}&sig=#{signature_params(Constant::APPID,url_params,url,"POST",Constant::APPKEY)}"
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(pars)
    respond=http.request(request)
    p respond.body
    respond_to do |format|
      format.json{
        render :json=>"成功"
      }
    end
  end

  #结果
  def result
    @sum = params[:sum].to_i
    messages = (cookies[:six] && cookies[:six]=="6") ? Constant::SCORE_LEVEL6 : Constant::SCORE_LEVEL
    if @sum == 4
      @score = rand(9)
      @message = messages[0]
    else
      @score = ((@sum-4)/2).to_i*10 + 10 + rand(9)
      @message = messages[(@sum-4)/2.to_i + 1]
    end
  end


end
