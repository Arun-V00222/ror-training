class WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :update, :destroy]

  # GET /wallets
  def index
    @wallets = Wallet.all
    render json: @wallets
  end

  # GET /wallets/1
  def show
    if Wallet.is_valid_user?(params[:id])
      render json: @wallet
    else
      render json: {'error': 'User is not allowed to perform this action. Not Authorized'}, status: :unprocessable_entity
    end
  end

  # POST /wallets
  def create
    @wallet = Wallet.new(wallet_params)
    if params[:is_primary]
      begin
        Wallet.update_previous_primary_wallet
      rescue Exception => ex
        Rails.logger.info("Error:")
        Rails.logger.info(ex)
      end
    end
    if @wallet.save
      render json: @wallet, status: :created, location: @wallet
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wallets/1
  def update
    if Wallet.is_valid_user?(params[:id])
      if @wallet.update(wallet_params)
        render json: @wallet
      else
        render json: @wallet.errors, status: :unprocessable_entity
      end
    else
      render json: {'error': 'User is not allowed to perform this action. Not Authorized'}, status: :unprocessable_entity
    end
  end

  # DELETE /wallets/1
  def destroy
    if Wallet.is_valid_user?(params[:id])
      if Wallet.update_primary_wallet(params[:id])
        @wallet.destroy
      end
      render json: {'message': 'Wallet deleted successfully'}, status: :ok
    else
      render json: {'error': 'User is not allowed to perform this action. Not Authorized'}, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def wallet_params
      Rails.logger.info("User info")
      Rails.logger.info(User.current_user)
      params.require(:wallet).permit(:amount, :is_active, :is_primary).merge(:user_id => User.current_user.id)
    end
end
