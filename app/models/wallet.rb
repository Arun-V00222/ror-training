class Wallet < ApplicationRecord
  belongs_to :user

  #class methods
  class << self

    def update_previous_primary_wallet
      begin
        @wallet = Wallet.where(:is_primary => true).first
        @wallet.is_primary = false
        @wallet.save!
      rescue Exception => e
        Rails.logger.error(e.message)
        raise 'Failed to update previous primary wallet'
      end
    end

    def is_valid_user?(wallet_id)
      @user = User.current_user
      Wallet.find_by(id: wallet_id , user_id: @user.id)
    end

    def update_primary_wallet(wallet_id)
        @wallet = Wallet.find_by(id: wallet_id, is_primary: true)
        if(@wallet)
          Rails.logger.info("Wallet : #{@wallet}")
          @next_primary_wallet = Wallet.where(:is_primary => false).order(:created_at).first
          Rails.logger.info("Next Wallet : #{@next_primary_wallet}")
          @next_primary_wallet.is_primary = true
          @next_primary_wallet.save!
        end
    end

  end

end
