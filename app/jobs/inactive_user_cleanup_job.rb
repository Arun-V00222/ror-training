class InactiveUserCleanupJob < ApplicationJob
  include Sidekiq::Worker
  queue_as :default
  rescue_from(ErrorLoadingSite) do
    retry_job wait: 5.minutes, queue: :low_priority
  end

  def perform(*args)
    @users = User.where('id NOT IN (SELECT DISTINCT(user_id) FROM wallets)')
    Rails.logger.info("Users : #{@users}")
    @users.each do |user|
      Rails.logger.info("User info : #{user}")
      user.destroy
    end
  end
end
