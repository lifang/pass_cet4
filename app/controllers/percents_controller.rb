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
  
  def create
    @total_score = params["ability"].to_i + params["heart"].to_i + params["attitude"].to_i
    @message = Constant::SCORE_LEVEL[@total_score]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def  renren_like
    app_id = @@renren_client_id
    redirect_to "http://widget.renren.com/dialog/friends?target_id=#{Constant::RENREN_ID}&app_id=#{app_id}&redirect_uri=#{Constant::SERVER_PATH}/percents/close_window"
  end

  def close_window
    render :inline=>"<script>window.close();</script>"
  end



  @@sina_app_key = "668934093"
  @@sina_app_secret = "bce8d1dcd35f257d1b46fd36e99f50c8"

  def sina
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

  def send_message
    @return_message = ""
    if params[:web] == "sina"
      ret = sina_send_message(cookies[:access_token], params[:message])
      puts ret
      @return_message = "微博发送失败，请重新尝试" if ret["error_code"]
    elsif params[:web] == "renren"
      ret = renren_send_message(cookies[:access_token], params[:message], @@renren_secret_key)
      @return_message = "分享失败，请重新尝试" if ret[:error_code]    
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

end
