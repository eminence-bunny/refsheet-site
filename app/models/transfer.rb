# == Schema Information
#
# Table name: transfers
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  item_id             :integer
#  sender_user_id      :integer
#  destination_user_id :integer
#  invitation_id       :integer
#  seen_at             :datetime
#  claimed_at          :datetime
#  rejected_at         :datetime
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Transfer < ApplicationRecord
  belongs_to :character
  belongs_to :item
  belongs_to :sender, class_name: User, foreign_key: :sender_user_id
  belongs_to :destination, class_name: User, foreign_key: :destination_user_id
  belongs_to :invitation

  scope :pending, -> { where status: :pending }

  validates_presence_of :sender
  validates_presence_of :destination, unless: -> (t) { t.invitation.present? }
  validates_presence_of :invitation, unless: -> (t) { t.destination.present? }
  validates_presence_of :character

  before_validation :assign_sender

  state_machine :status, initial: :pending do
    before_transition :pending => :rejected, do: :reject_transfer
    before_transition :pending => :claimed, do: :claim_transfer

    state :rejected do
      validates_presence_of :rejected_at
    end

    state :claimed do
      validates_presence_of :claimed_at
    end

    event :claim do
      transition :pending => :claimed
    end

    event :reject do
      transition :pending => :rejected
    end
  end

  private

  def assign_sender
    self.sender ||= self.character.user
  end

  def claim_transfer
    self.character.update_attributes user: self.destination
    self.claimed_at = DateTime.now
    # TODO notify the sender
  end

  def reject_transfer
    self.rejected_at = DateTime.now
    # TODO notify the sender
  end
end
