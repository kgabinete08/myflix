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
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
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
end