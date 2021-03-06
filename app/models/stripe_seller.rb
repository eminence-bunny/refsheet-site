# == Schema Information
#
# Table name: sellers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  type                :string
#  address_id          :integer
#  processor_id        :string
#  first_name          :string
#  last_name           :string
#  dob                 :datetime
#  tos_acceptance_date :datetime
#  tos_acceptance_ip   :string
#  default_currency    :string
#  processor_type      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_sellers_on_type     (type)
#  index_sellers_on_user_id  (user_id)
#

class StripeSeller < Seller
  attr_accessor :personal_id_token

  validates_presence_of :dob
  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_inclusion_of :processor_type, in: %w(standard custom)

  after_commit :create_stripe_account

  def get_processor_account
    Stripe::Account.retrieve self.processor_id
  end

  private

  def create_stripe_account
    legal_entity = {
        first_name: self.first_name,
        last_name: self.last_name
    }

    tos_acceptance = {
        date: self.tos_acceptance_date,
        ip: self.tos_acceptance_ip
    }

    options = {
        type: (self.processor_type || 'standard'),
        email: self.user.email,
        country: 'US',
        default_currency: self.default_currency,
        legal_entity: legal_entity,
        tos_acceptance: tos_acceptance,
        personal_id_number: self.personal_id_token
    }

    if self.processor_id.nil?
      account = Stripe::Account.create options
      self.update_columns processor_id: account.id, processor_type: account.type
    else
      self.get_processor_account&.update options
    end
  end
end
