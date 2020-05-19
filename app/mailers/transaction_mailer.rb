class TransactionMailer < ApplicationMailer
  def transaction_email
    @transaction = params[:transaction]
    @url  = 'http://example.com/login'
    mail(to: @transaction[:receiver_email], subject: 'Amount credited in your wallet')
  end
end
