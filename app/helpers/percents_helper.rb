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
  def sig_renren(query,api_serect)
    str=""
    query.sort.each{|key,value|str<<"#{key}=#{value}"}
    str << api_serect
    query[:sig]=Digest::MD5.hexdigest(str)
    return query
  end

  # 带图片微博
  def renren_send_pic(access_token,img_url,api_serect)
    query={"access_token" =>access_token,:format => 'JSON', :method => 'photos.upload',:v => '1.0'}
    url = URI.parse("http://api.renren.com/restserver.do")
    File.open("#{Rails.root}/public/#{img_url}") do |jpg|
      req = Net::HTTP::Post::Multipart.new url.path,sig_renren(query,api_serect).merge!("upload" => UploadIO.new(jpg, "image/jpeg", "image.jpg"))
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      info= http.request(req).body
      return info
    end
   
  end

end
