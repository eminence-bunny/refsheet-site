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
#
# Indexes
#
#  index_characters_profile_widgets_on_character_id        (character_id)
#  index_characters_profile_widgets_on_guid                (guid)
#  index_characters_profile_widgets_on_profile_section_id  (profile_section_id)
#  index_characters_profile_widgets_on_row_order           (row_order)
#

class Characters::ProfileWidget < ApplicationRecord
  module Types
    RICH_TEXT = 'RichText'
  end

  include HasGuid

  belongs_to :character
  belongs_to :profile_section, class_name: 'Characters::ProfileSection'

  validates_numericality_of :column,
                            only_integer: true,
                            less_than: 12,
                            greater_than_or_equal_to: 0

  has_guid
  ranks :row_order, with_same: [:profile_section_id, :column]
  serialize :data

  before_validation :assign_default_data
  before_save :serialize_rich_text_widget, if: -> (w) { w.widget_type == Types::RICH_TEXT }

  private

  def assign_default_data
    if data.nil?
      self.data = {}
    elsif ! data.kind_of? Hash
      self.data = {value: self.data}
    end
  end

  def serialize_rich_text_widget
    content = data[:content]&.to_md

    Rails.logger.info(content.inspect)
    Rails.logger.info(content)

    self.data[:content_html] = content&.to_html
  end

end
