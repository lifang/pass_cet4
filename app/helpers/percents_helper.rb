# encoding: utf-8
module PercentsHelper
  

  #公共方法加密url及生成签名：
  def signature_params(key,sign,url,method,secret)
    signature="#{method}&#{url_encoding(url)}&#{CGI.escape(sign)}"
    return url_encoding(Base64.encode64(OpenSSL::HMAC.digest("sha1","#{key}&#{secret}",signature)))
  end

  def url_encoding(str)
    str.gsub("=", "%3D").gsub("/","%2F").gsub(":","%3A").gsub("&","%26").gsub("+","%2B")
  end

  #构造post请求
  def create_post_http(url,route_action,params)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Post.new(route_action)
    request.set_form_data(params)
    return JSON http.request(request).body
  end

  #构造get请求
  def create_get_http(url,route)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request= Net::HTTP::Get.new(route)
    back_res =http.request(request)
    return JSON back_res.body
  end

  #人人网签名
  def sig_renren(query)
    str=""
    query.sort.each{|key,value|str<<"#{key}=#{value}"}
    str<<RENREN_API_SECRET
    query[:sig]=Digest::MD5.hexdigest(str)
    return query
  end

 

  #人人获取用户信息
  def renren_get_user(access_token)
    query = {:access_token => access_token,:format => 'JSON',:method => 'xiaonei.users.getInfo',:v => '1.0'}
    response=create_post_http("http://api.renren.com","/restserver.do",sig_renren(query))
  end
  #
  #人人发送新鲜事
  def renren_send_message(access_token,message,other_parms=nil)
    other_parms={:type=>"6",:url=>"http://www.gankao.co"} if other_parms.nil?
    query = {:access_token => "#{access_token}",:comment=>"#{message}",:format => 'JSON',:method => 'share.share',:v => '1.0'}
    query.merge!(other_parms)
    response=create_post_http("http://api.renren.com","/restserver.do",sig_renren(query))
    return response
  end

  
end
