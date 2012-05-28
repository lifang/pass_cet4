# encoding: utf-8
module ApplicationHelper

  require 'net/http'
  #START -----人人API
  #人人主方法
  def renren_api(request)
    uri = URI.parse("http://api.renren.com")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request).body
  end
  #
  #构成人人签名请求
  def renren_sig_request(query,secret_key)
    str = ""
    query.sort.each{|key,value|str<<"#{key}=#{value}"}
    str<<secret_key
    sig = Digest::MD5.hexdigest(str)
    query[:sig]=sig
    request = Net::HTTP::Post.new("/restserver.do")
    request.set_form_data(query)
    return request
  end
  #
  #人人获取用户信息
  def renren_get_user(access_token,secret_key)
    query = {:access_token => access_token,:format => 'JSON',:method => 'xiaonei.users.getInfo',:v => '1.0'}
    request = renren_sig_request(query,secret_key)
    response = JSON renren_api(request)
  end
  #
  #人人发送新鲜事
  def renren_send_message(access_token,message,secret_key,type)
    url = type=="4" ? "http://apps.renren.com/wantcet" : "http://apps.renren.com/wantsix"
    query = {:access_token => "#{access_token}",:comment=>"#{message}",:format => 'JSON',
      :method => 'share.share',:type=>"6",:url=>url,:v => '1.0'}
    request = renren_sig_request(query,secret_key)
    response =JSON renren_api(request)
  end
  #
  #END -------人人API----------


  #START ---------SINA-------------
  #新浪微博主方法
  def sina_api(request)
    uri = URI.parse("https://api.weibo.com")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request).body
  end
  #
  #新浪微博发送微博
  def sina_send_message(access_token,message)
    request = Net::HTTP::Post.new("/2/statuses/update.json")
    request.set_form_data({"access_token" =>access_token, "status" => message})
    response =JSON sina_api(request)
  end
  #
  #新浪微博关注赶考网官方微博
  def sina_guanzhu(access_token,uid)
    request = Net::HTTP::Post.new("/2/friendships/create.json")
    request.set_form_data({"access_token" =>access_token, "uid" => uid})
    response =JSON sina_api(request)
  end
  #END ------------SINA------------
end
