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

  class Customer
    attr_reader :response, :error_message

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          source: options[:source],
          email: options[:user].email,
          plan: "myflix_plan"
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end
end
