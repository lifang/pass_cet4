# encoding: utf-8
class TencentsController < ApllicationController
  include TencentHelper

  
  def qqzone_request
    redirect_to "#{TencentHelper::REQUEST_URL_QQ}?#{TencentHelper::REQUEST_ACCESS_TOKEN.map{|k,v|"#{k}=#{v}"}.join("&")}"
  end
end