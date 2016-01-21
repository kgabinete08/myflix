require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: 11,
        exp_year: Time.now.year + 2,
        cvc: "590"
      },
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: 11,
        exp_year: Time.now.year + 2,
        cvc: "590"
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: valid_token,
          description: "A valid charge."
        )
        expect(response).to be_successful
      end

      it "makes a declined charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_card_token,
          description: "An invalid charge."
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: declined_card_token,
          description: "An invalid charge."
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer when card is valid", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response.customer_token).to be_present
      end

      it "does not create a customer when card is declined", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_card_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_card_token,
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
