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
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#  nsfw              :boolean
#  hidden            :boolean
#  secret            :boolean
#

class Character < ApplicationRecord
  include HasGuid
  include Sluggable

  belongs_to :user
  belongs_to :color_scheme, autosave: true
  belongs_to :featured_image, class_name: Image
  belongs_to :profile_image, class_name: Image
  has_many :swatches
  has_many :images

  has_guid :shortcode, type: :token
  slugify :name, scope: :user
  scoped_search on: [:name, :species, :profile, :likes, :dislikes]

  accepts_nested_attributes_for :color_scheme

  validates_presence_of :user

  validates :name,
            presence: true,
            format: { with: /[a-z]/i, message: 'must have at least one letter' }

  validate :validate_profile_image
  validate :validate_featured_image

  scope :default_order, -> do
    order(<<-SQL)
      CASE
        WHEN characters.profile_image_id IS NULL THEN '1'
        WHEN characters.profile_image_id IS NOT NULL THEN '0'
      END, lower(characters.name) ASC
    SQL
  end

  scope :sfw, -> { where(nsfw: [nil, false]) }
  scope :visible, -> { where(hidden: [nil, false]) }

  before_validation do
    self.shortcode = self.shortcode&.downcase
  end

  def description
    ''
  end

  def nickname
    ''
  end

  def profile_image
    super || Image.new
  end

  def managed_by?(user)
    self.user == user
  end

  def self.lookup(slug)
    find_by('LOWER(characters.slug) = ?', slug.downcase)
  end

  def self.lookup!(slug)
    find_by!('LOWER(characters.slug) = ?', slug.downcase)
  end

  def self.find_by_shortcode!(shortcode)
    find_by!('LOWER(characters.shortcode) = ?', shortcode.downcase)
  end

  private

  def validate_profile_image
    unless self.profile_image.nil?
      self.errors.add :profile_image, 'cannot be NSFW' if self.profile_image.nsfw?
      false
    end
  end

  def validate_featured_image
    unless self.featured_image.nil?
      self.errors.add :featured_image, 'cannot be NSFW' if self.featured_image.nsfw?
      false
    end
  end
end
