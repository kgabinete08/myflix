require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 11,
            :exp_year => 2017,
            :cvc => "590"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: "A valid charge."
        ) 

        expect(response.amount).to eq(999)
        expect(response.currency).to eq("usd")
      end
    end
  end
end
