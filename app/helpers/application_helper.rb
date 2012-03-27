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
  def renren_send_message(access_token,message,secret_key)
    query = {:access_token => "#{access_token}",:comment=>"#{message}",:format => 'JSON',:method => 'share.share',:type=>"6",:url=>"http://www.gankao.co",:v => '1.0'}
    request = renren_sig_request(query,secret_key)
    response =JSON renren_api(request)
  end
  #
  #END -------人人API----------


end
