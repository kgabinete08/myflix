require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "redirects non admin users to the home path" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets flash message for non admin users" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "creates the video"
      it "redirects to the add new video pagee"
      it "sets the flash success message"
    end

    context "with invalid input" do
      it "does not create a video"
      it "renders the new template"
      it "sets @video"
      it "sets the flash danger message"
    end
  end
end