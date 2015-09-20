require 'spec_helper'

describe PasswordResetsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "sets the error message" do
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end
    end

    context "with email that exists in the database" do
      it "redirects to the password reset confirmation page" do
        Fabricate(:user, email: 'bob@example.com')
        post :create, email: 'bob@example.com'
        expect(response).to redirect_to password_reset_confirmation_url
      end

      it "sends out an email to the email address" do
        Fabricate(:user, email: 'bob@example.com')
        post :create, email: 'bob@example.com'
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end
    end

    context "with email that does not exist in the database" do
      it "redirects to the forgot password page" do
        post :create, email: 'bob@example.com'
        expect(response).to redirect_to forgot_password_url
      end

      it "sets the error message" do
        post :create, email: 'bob@example.com'
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "GET edit" do
    it "renders show template if reset token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:reset_token, '12345')
      get :edit, id: '12345'
      expect(response).to render_template :edit
    end

    it "redirects to the expired token page if auth token is invalid" do
      get :edit, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "PATCH update" do
    context "with valid reset_token" do
      let!(:alice) { Fabricate(:user, password: 'old_password', reset_token: '12345') }

      before do
        patch :update, id: '12345', user: { password: 'new_password' }
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do
        expect(alice.reload.authenticate('new_password')).to eq(alice)
      end

      it "set the success message" do
        expect(flash[:success]).to be_present
      end

      it "clears the user's reset token" do
        expect(alice.reload.reset_token).to be_nil
      end
    end

    context "with invalid reset_token" do
      it "redirects to the expired token path" do
        patch :update, id: 12345, user: { password: 'some_password' }
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end