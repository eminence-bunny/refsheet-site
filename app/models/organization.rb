# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  username            :string
#  email               :string
#  password_digest     :string
#  profile             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  settings            :json
#  type                :string
#  auth_code_digest    :string
#  parent_user_id      :integer
#  unconfirmed_email   :string
#  email_confirmed_at  :datetime
#

class Organization < User
  has_many :memberships
  has_many :admin_memberships, -> { admin }, class_name: Membership
  has_many :users, through: :memberships
  has_many :admins, through: :admin_memberships, class_name: User

  belongs_to :owner, class_name: User, foreign_key: :parent_user_id

  validates_presence_of :owner
end