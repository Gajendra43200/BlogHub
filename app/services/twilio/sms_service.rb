require 'twilio-ruby'
module Twilio
    class SmsService
        def initialize(to_phone_number)
            @to_phone_number = to_phone_number
           
        end
        def call 
            @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
            message = @client.messages.create(
              body: 'You signed up successfully. Welcome to BlogHub!',
              from: ENV["TWILIO_PHONE_FROM_NUMBER"],
              to: to(@to_phone_number)
            )
            puts message.sid
         end

         private
        
         def to(to_phone_number)
            return ENV["TWILIO_PHONE_TO_NUMBER"] if Rails.env.development?
            to_phone_number
        end
    end
end