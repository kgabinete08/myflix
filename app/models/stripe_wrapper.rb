module StripeWrapper
  class Charge
    def self.create(charge = {})
      Stripe::Charge.create(
        amount: charge[:amount],
        currency: "usd",
        source: charge[:card],
        description: charge[:description]
      )
    end
  end
end
