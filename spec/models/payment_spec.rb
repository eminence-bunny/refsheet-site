# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  order_id            :integer
#  processor_id        :string
#  amount_cents        :integer          default(0), not null
#  amount_currency     :string           default("USD"), not null
#  state               :string
#  failure_reason      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type                :string
#  processor_fee_cents :integer
#
# Indexes
#
#  index_payments_on_order_id      (order_id)
#  index_payments_on_processor_id  (processor_id)
#  index_payments_on_type          (type)
#

require 'rails_helper'

describe Payment, type: :model do
  it_is_expected_to(
    belong_to: :order,
    validate_numericality_of: :amount_cents
  )
end
