# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  url        :string
#  shortcode  :string
#  profile    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Character, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
