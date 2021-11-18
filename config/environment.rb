# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
    user_name:      'dhruti3699@gmail.com',
    password:       'dkk.g@*3699',
    address:       'smtp.gmail.com',
    port:          '465',
    domain: 'gmail.com',
    authentication: :plain,
    :ssl => true,
    :tsl => true,
    enable_starttls_auto: true
  }
