# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#
# Indexes
#
#  index_roles_on_name  (name)
#

class Role < ApplicationRecord
  has_many :permissions
  has_many :users, through: :permissions

  @@id_cache = {}

  ADMIN = 'admin'
  MODERATOR = 'moderator'

  validates :name, presence: true, uniqueness: true, format: { with: /\A\w+\z/, message: 'must be sym' }
  before_validation -> { name&.downcase! }
  before_validation :bump_cache

  def self.[](role)
    find_by name: role
  end

  def self.id_for(role)
    @@id_cache[role] ||= find_by(name: role)&.id
  end

  private

  def bump_cache
    @@id_cache&.delete name
  end
end
