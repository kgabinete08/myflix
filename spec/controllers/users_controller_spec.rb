require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: invitation.recipient_email, password: 'password', full_name: 'Bob Jones' }, invitation_token: invitation.token
        bob = User.find_by(email: 'bob@example.com')
        expect(bob.already_follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: invitation.recipient_email, password: 'password', full_name: 'Bob Jones' }, invitation_token: invitation.token
        bob = User.find_by(email: 'bob@example.com')
        expect(alice.already_follows?(bob)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')
        post :create, user: { email: invitation.recipient_email, password: 'password', full_name: 'Bob Jones' }, invitation_token: invitation.token
        bob = User.find_by(email: 'bob@example.com')
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with invalid input" do
      before do
        post :create, user: { email: "bob@abc.com", password: "password" }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "send welcome email" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends the email when a user is created with valid input" do
        post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Jones' }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sends email with user's name with valid input" do
        post :create, user: { email: 'bob@example.com', password: 'password', full_name: 'Bob Jones' }
        expect(ActionMailer::Base.deliveries.last.body).to include('Bob Jones')
      end

      it "does not send an email when input is invalid" do
        post :create, user: { email: 'bob@example.com' }
        expect(ActionMailer::Base.deliveries).to be_empty
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