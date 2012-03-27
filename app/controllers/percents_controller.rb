# encoding: utf-8
class PercentsController < ApplicationController
  
  def create
    total_score = params["ability"].to_i + params["heart"].to_i + params["attitude"].to_i
    @message = Constant::SCORE_LEVEL[total_score]
    respond_to do |format|
      format.html
      format.js
    end
  end
end
