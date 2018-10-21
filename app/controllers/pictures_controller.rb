# frozen_string_literal: true

class PicturesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_ownership

  def index
    @pictures = current_user.pictures
  end

  def new
    @picture = Picture.new(user_id: current_user.id)
  end

  def create
    picture = Picture.new(picture_params)
    if picture.save
      flash[:notice] = 'Picture successfully created'
      redirect_to user_pictures_path(current_user)
    else
      @picture = picture
      render :new
    end
  end

  private

  def ensure_ownership
    redirect_to root_path unless authorized_user?
  end

  def authorized_user?
    current_user && current_user.id == params[:user_id].to_i
  end

  def picture_params
    params.require(:picture).permit(
      :title, :user_id, :image
    )
  end
end
