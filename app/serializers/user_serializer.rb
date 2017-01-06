class UserSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag::InstanceMethods

  attributes :username, :email, :avatar_url, :path, :name, :profile_image_url, :cover_image_url, :profile, :profile_markup

  has_many :characters, serializer: ImageCharacterSerializer

  def avatar_url
    gravatar_image_url object.email
  end

  def profile_image_url
    '/assets/unsplash/fox.jpg'
  end

  def cover_image_url
    '/assets/unsplash/sand.jpg'
  end

  def path
    "/users/#{object.username}/"
  end

  def profile_markup
    object.profile || ''
  end

  def profile
    linkify profile_markup
  end
end
