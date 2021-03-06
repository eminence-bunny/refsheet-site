# == Schema Information
#
# Table name: characters_profile_widgets
#
#  id                 :integer          not null, primary key
#  guid               :string
#  character_id       :integer
#  profile_section_id :integer
#  column             :integer
#  row_order          :integer
#  widget_type        :string
#  title              :string
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#
# Indexes
#
#  index_characters_profile_widgets_on_character_id        (character_id)
#  index_characters_profile_widgets_on_deleted_at          (deleted_at)
#  index_characters_profile_widgets_on_guid                (guid)
#  index_characters_profile_widgets_on_profile_section_id  (profile_section_id)
#  index_characters_profile_widgets_on_row_order           (row_order)
#

require 'rails_helper'

RSpec.describe Characters::ProfileWidget, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
