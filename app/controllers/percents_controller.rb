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

end
