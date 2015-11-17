module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(charge = {})
      begin
        response = Stripe::Charge.create(
          amount: charge[:amount],
          currency: "usd",
          source: charge[:source],
          description: charge[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end
