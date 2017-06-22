# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  email      :string
#  seen_at    :datetime
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :invitation do
    email { Faker::Internet.email }
  end
end
