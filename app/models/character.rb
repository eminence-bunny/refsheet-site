# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#

class Character < ApplicationRecord
  include HasGuid
  include Sluggable

  belongs_to :user
  has_many :swatches
  has_many :images
  has_one  :featured_image, class_name: Image
  has_one  :profile_image, class_name: Image

  has_guid :shortcode, type: :token
  slugify :name, scope: :user

  validates_presence_of :user
  validates_presence_of :name

  validates_uniqueness_of :shortcode

  def description
    ''
  end

  def nickname
    ''
  end

  def profile_image
    super || Image.new
  end
end
