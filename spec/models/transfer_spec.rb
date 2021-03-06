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
#  guid                :string
#
# Indexes
#
#  index_transfers_on_character_id         (character_id)
#  index_transfers_on_destination_user_id  (destination_user_id)
#  index_transfers_on_guid                 (guid)
#  index_transfers_on_item_id              (item_id)
#  index_transfers_on_sender_user_id       (sender_user_id)
#  index_transfers_on_status               (status)
#

require 'rails_helper'

describe Transfer, type: :model do
  it_is_expected_to(
    belong_to: [
      :character,
      :item,
      :sender,
      :destination,
      :invitation
    ],
    validate_presence_of: [
      :sender,
      :destination,
      :invitation,
      :character
    ]
  )

  it 'cannot claim with invite' do
    user = create :user, :is_seller
    character = create :character, user: user
    item = Marketplace::Items::CharacterListing.create!(seller: user.seller, user: user, character: character, amount: 4500)
    transfer = create :transfer, character: character, destination: nil, invitation: Invitation.create(email: 'foo@example.com'), item: item
    transfer.claim!
    expect(transfer).to be_pending
    expect(transfer).to be_sold
    transfer.invitation.user = create :user
    transfer.invitation.claim!
    expect(transfer.reload).to be_claimed
  end

  describe 'mailers' do
    context 'when sending' do
      let(:transfer) { build :transfer }

      it 'sends incoming mailer' do
        expect(TransferMailer).to receive(:incoming).and_call_original
        transfer.save!
      end
    end

    context 'when replying' do
      let(:transfer) { create :transfer }

      it 'sends rejected mailer' do
        expect(TransferMailer).to receive(:rejected).and_call_original
        transfer.reject!
      end

      it 'sends accepted mailer' do
        expect(TransferMailer).to receive(:accepted).and_call_original
        transfer.claim!
      end
    end
  end

  context 'when rejected' do
    let(:transfer) { build :transfer, status: :rejected }
    subject { transfer }
    it_is_expected_to validate_presence_of: :rejected_at
  end

  context 'when claimed' do
    let(:transfer) { build :transfer, status: :claimed }
    subject { transfer }
    it_is_expected_to validate_presence_of: :claimed_at
  end
end
