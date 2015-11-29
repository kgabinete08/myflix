require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with successful user sign up" do
      it "redirects to the sign in page" do
        result = double(:sign_up_result, successful?: true)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "sets the flash success message" do
        result = double(:sign_up_result, successful?: true)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:success]).to be_present
      end
    end

    context "failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Error message.")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123456789'
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        result = double(:sign_up_result, successful?: false, error_message: "Errormessage.")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123456789'
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user for authenticated users" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects expired token page when token is invalid" do
      get :new_with_invitation_token, token: 'randomgibberish'
      expect(response).to redirect_to expired_token_path
    end
  end
end
