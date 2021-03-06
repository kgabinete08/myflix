require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders :new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home page for authenticated users" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      before do
        @alice = Fabricate(:user)
        post :create, email: @alice.email, password: @alice.password
      end

      it "puts the signed in user into the session" do
        expect(session[:user_id]).to eq(@alice.id)
      end

      it "sets the flash success message" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid credentials" do
      before do
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'gibberish'
      end

      it "does not put the user into the session" do
        expect(session[:user_id]).to be_nil
      end

      it "sets the flash error message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "GET destroy" do
    before do
      set_current_user
      get :destroy
    end

    it "clears the session for the user" do
      expect(session[:user_id]).to be_nil
    end

    it "sets the flash success message" do
      expect(flash[:success]).not_to be_blank
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end
  end
end