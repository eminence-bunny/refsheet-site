# == Schema Information
#
# Table name: forum_karmas
#
#  id          :integer          not null, primary key
#  karmic_id   :integer
#  karmic_type :integer
#  user_id     :integer
#  discord     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Forum::Karma, type: :model do
  it_is_expected_to(
      belong_to: [
          :karmic,
          :user
      ],
      validate_presence_of: [
          :karmic,
          :user
      ]
  )
end
