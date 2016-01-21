require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    context 'with valid personal info and accepted card' do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdef") }
      before { allow(StripeWrapper::Customer).to receive(:create).and_return(customer) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdef")
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'Bob Jones')).sign_up('stripe_token', invitation.token)
        bob = User.find_by(email: 'bob@example.com')
        expect(bob.already_follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'Bob Jones')).sign_up('stripe_token', invitation.token)
        bob = User.find_by(email: 'bob@example.com')
        expect(alice.already_follows?(bob)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'Bob Jones')).sign_up('stripe_token', invitation.token)
        bob = User.find_by(email: 'bob@example.com')
        expect(Invitation.first.token).to be_nil
      end

      it "sends the email when a user is created with valid input" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'Bob Jones')).sign_up('stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sends email with user's name with valid input" do
        UserSignup.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'Bob Jones')).sign_up('stripe_token', nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Bob Jones')
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:charge, successful?: false, error_message: 'Your card was declined.')
        allow(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('123456789', nil)
        expect(User.count).to eq(0)
      end
    end

    context "invalid personal info" do
      after { ActionMailer::Base.deliveries.clear }
      before { UserSignup.new(User.new(email: 'bob@abc.com', password: 'password')) }

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).not_to receive(:create)
      end

      it "does not send an email when input is invalid" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
