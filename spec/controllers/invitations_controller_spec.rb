require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    before { set_current_user }

    context "with valid input" do
      it "redirects to the new invitation page" do
        post :create, invitation: { recipient_email: 'bob@example.com', recipient_name: 'Bob Jones', message: 'Sign up for MyFlix!'}
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        post :create, invitation: { recipient_email: 'bob@example.com', recipient_name: 'Bob Jones', message: 'Sign up for MyFlix!'}
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        post :create, invitation: { recipient_email: 'bob@example.com', recipient_name: 'Bob Jones', message: 'Sign up for MyFlix!'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bob@example.com'])
      end

      it "sets the flash success message" do
        post :create, invitation: { recipient_email: 'bob@example.com', recipient_name: 'Bob Jones', message: 'Sign up for MyFlix!'}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input"
  end
end