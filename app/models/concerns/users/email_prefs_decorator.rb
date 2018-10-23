module Users::EmailPrefsDecorator
  extend ActiveSupport::Concern

  included do
    has_settings do |s|
      s.key :email, defaults: {
          mailing_list: nil,
          internal_blacklist: [],
          opt_out_all: false
      }
    end
  end

  def email_allowed?(key=:all)
    key = key.to_s.downcase.to_sym
    if email_prefs.opt_out_all || email_prefs.internal_blacklist.include?(key)
      Rails.logger.info("User #{self.id} forbids email: #{key}")
      false
    else
      true
    end
  end

  def allow_email!(key=:all)
    change_email! key, true
  end

  def block_email!(key=:all)
    change_email! key, false
  end

  def change_email!(key=:all, allow=true)
    key = key.to_s.downcase.to_sym
    blacklist = email_prefs.internal_blacklist.dup || []

    if allow
      blacklist.delete key
    else
      blacklist.push key
    end

    email_prefs.update_attributes! internal_blacklist: blacklist
  end

  def block_all_email!
    email_prefs.update_attributes! opt_out_all: true
    block_email! :all
  end

  def allow_all_email!
    email_prefs.update_attributes! opt_out_all: false
    allow_email! :all
  end

  private

  def email_prefs
    self.settings(:email)
  end
end
