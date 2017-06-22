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
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    profile { Faker::Lorem.paragraph }
    password 'fishsticks'
    password_confirmation 'fishsticks'
    skip_emails true

    sequence :username do |n|
      "user#{n}"
    end

    sequence :email do |n|
      "user#{n}@example.com"
    end

    trait :send_emails do
      skip_emails false
    end

    factory :admin do
      roles {[ Role.find_or_initialize_by(name: 'admin') ]}
    end
  end
end
