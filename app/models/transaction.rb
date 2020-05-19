class Transaction < ApplicationRecord

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  belongs_to :wallet

  after_save :update_receiver_wallet

  private
  def update_receiver_wallet
    @last_transaction = Transaction.order(:created_at).last
    @transaction_amount = @last_transaction.amount
    Rails.logger.info("Last transaction amount #{@last_transaction.id} : #{@transaction_amount}")
    @user_id = @last_transaction.receiver_id
    @user = User.find_by_id(@user_id)
    @wallet_optional = @user.wallets.find_by(:is_primary => true)
    Rails.logger.info("Wallet info : #{@wallet_optional}")
    if @wallet_optional
      @wallet = @wallet_optional
      @wallet.amount += @transaction_amount
      @wallet.update!(amount: @wallet.amount)
    else
      @wallet = Wallet.where(:user_id => @user_id).first
      @wallet.amount += @transaction_amount
      @wallet.update!(amount: @wallet.amount)
    end
    @mail_params = Hash.new
    @mail_params[:amount] = @transaction_amount
    @mail_params[:sender] = User.current_user.user_name
    @mail_params[:receiver_email] = User.find_by_id(@last_transaction.receiver_id).user_email
    @mail_params[:receiver_name] = User.find_by_id(@last_transaction.receiver_id).user_name
    TransactionMailer.with(transaction: @mail_params).transaction_email.deliver_later
  end
  #class methods
  class << self
    def get_wallet_walance(wallet_id)
      begin
        @wallet = Wallet.where(:id => wallet_id).first
        @wallet.amount
      rescue Exception => e
        Rails.logger.error(e.message)
        0.to_f
      end
    end

    def make_transaction(amount, wallets, receiver_id)
      begin
        Transaction.transaction do
          @amount_to_transfer = amount
          wallets.each do |wallet|
            next if @amount_to_transfer < 0
            @wallet = Wallet.where(:id => wallet).first
            if(@amount_to_transfer > @wallet.amount)
              @transaction = @wallet.transactions.create!(:amount => @wallet.amount, :receiver_id => receiver_id, :sender_id => User.current_user.id)
            else
              @transaction = @wallet.transactions.create!(:amount => @amount_to_transfer, :receiver_id => receiver_id, :sender_id => User.current_user.id)
            end
            balance = (@wallet.amount - @amount_to_transfer > 0) ? (@wallet.amount - @amount_to_transfer) : 0
            @amount_to_transfer -= @wallet.amount
            @wallet.update!(amount: balance)
          end
        end
      rescue Exception => e
        Rails.logger.error(e.message)
        raise 'Transaction failed'
      end
    end
  end

end
