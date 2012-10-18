# encoding: utf-8
class ImagesController < ApplicationController
  require 'RMagick'

  def create
    rmagick = params[:score]
    bg = Magick::ImageList.new("#{Rails.root}/public/#{params[:current_type]}.jpg")
    i = Magick::ImageList.new
    i.new_image(800, 628) { self.background_color = 'transparent' }
    primitives = Magick::Draw.new
    primitives.annotate i, 0, 0, 20, 10, rmagick do
      #self.font="#{Rails.root}/public/simhei.ttf"
      self.pointsize = 160
      self.fill = "#F6E7BC"
      self.stroke = "white"
      self.font_weight = Magick::BoldWeight
      self.gravity = Magick::CenterGravity
    end
    begin
      result = bg.composite_layers(i)
      result.delay = 10
      result.write("#{Rails.root}/public/composite_layers.gif")
    rescue NotImplementedError
    end
  end
  
end
