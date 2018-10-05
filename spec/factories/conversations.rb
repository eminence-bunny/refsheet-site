# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  approved     :boolean
#  subject      :string
#  muted        :boolean
#  guid         :string
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_conversations_on_guid          (guid)
#  index_conversations_on_recipient_id  (recipient_id)
#  index_conversations_on_sender_id     (sender_id)
#

FactoryBot.define do
  factory :conversation do
    sender_id { "" }
    recipient_id { "" }
    approved { false }
    subject { "MyString" }
    muted { false }
    guid { "MyString" }
    deleted_at { "2018-10-05 13:21:46" }
  end
end
