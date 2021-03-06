# == Schema Information
#
# Table name: auctions
#
#  id                        :integer          not null, primary key
#  item_id                   :integer
#  slot_id                   :integer
#  starting_bid_cents        :integer          default(0), not null
#  starting_bid_currency     :string           default("USD"), not null
#  minimum_increase_cents    :integer          default(0), not null
#  minimum_increase_currency :string           default("USD"), not null
#  starts_at                 :datetime
#  ends_at                   :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_auctions_on_ends_at    (ends_at)
#  index_auctions_on_starts_at  (starts_at)
#

class Auction < ApplicationRecord
end
