# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :integer
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Forum::Post < ApplicationRecord
  include HasGuid

  belongs_to :user
  belongs_to :character
  belongs_to :thread, class_name: Forum::Discussion, foreign_key: :thread_id
  belongs_to :parent_post, class_name: Forum::Post, foreign_key: :parent_post_id
  has_many :replies, class_name: Forum::Post, foreign_key: :parent_post_id
  has_many :karmas, class_name: Forum::Karma, foreign_key: :karmic_id, as: :karmic
  has_one :forum, through: :thread, class_name: Forum

  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :thread

  has_guid
end