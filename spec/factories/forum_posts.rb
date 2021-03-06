# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :string
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  content_html   :string
#  admin_post     :boolean          default(FALSE)
#  moderator_post :boolean          default(FALSE)
#  deleted_at     :datetime
#  edited         :boolean          default(FALSE)
#
# Indexes
#
#  index_forum_posts_on_character_id    (character_id)
#  index_forum_posts_on_deleted_at      (deleted_at)
#  index_forum_posts_on_guid            (guid)
#  index_forum_posts_on_parent_post_id  (parent_post_id)
#  index_forum_posts_on_thread_id       (thread_id)
#  index_forum_posts_on_user_id         (user_id)
#

FactoryBot.define do
  factory :forum_post, class: 'Forum::Post' do
    association :discussion, factory: :forum_discussion
    user
    content { Faker::Lorem.paragraph }
  end
end
