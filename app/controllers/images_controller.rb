class ImagesController < ApplicationController
  before_action :get_user, except: [:show, :update, :destroy]
  before_action :get_character, except: [:show, :update, :destroy]
  before_action :get_image, only: [:show, :update, :destroy]

  respond_to :json

  def index
    render json: @character.images.rank(:row_order), each_serializer: ImageSerializer
  end

  def show
    render json: @image, serializer: ImageSerializer
  end

  def create
    @image = Image.new image_params.merge(character: @character)

    if @image.save
      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def update
    if @image.update_attributes image_params
      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def destroy
    @image.destroy
    render json: @image, serializer: ImageSerializer
  end

  private

  def get_user
    @user = User.find_by!(username: params[:user_id])
  end

  def get_character
    @character = @user.characters.find_by!(slug: params[:character_id])
  end

  def get_image
    @image = Image.find_by!(guid: params[:id])
  end

  def image_params
    params.require(:image).permit(:image, :artist_id, :caption, :source_url)
  end
end
