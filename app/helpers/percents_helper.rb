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

 

end
