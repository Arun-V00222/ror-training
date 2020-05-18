class TransactionController < ApplicationController

  before_action :set_transaction, only: [:show]

  # GET /transaction
  def index
    @user = User.current_user
    @transactions = @user.transactions.all
    render json: @transactions

  end

  # GET /transaction/1
  def show
    render json: @transaction
  end

  # POST /transaction
  def create
    if User.validate_user(params[:receiver_id])
      @wallet_balance = 0
      @wallet_ids = params[:wallet_ids]
      @wallet_ids.each do |wallet_id|
        @wallet_balance += Transaction.get_wallet_walance(wallet_id)
      end
      if @wallet_balance > params[:amount]
        Transaction.make_transaction(params[:amount], @wallet_ids, params[:receiver_id])
        render json: {'message': 'Transaction Created successfully'}, status: :created
      else
        render json: {'error': 'Wallet balance is insufficient'}, status: :unprocessable_entity
      end
    else
      render json: {'error': 'Receiver does not exist in the system'}, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @user = User.current_user
      @wallet = @user.transactions.find(params[:id])
    end

end
