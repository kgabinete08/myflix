require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects unauthenticated users to the sign in page" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      family_guy = Fabricate(:video, title: 'Family Guy')
      post :search, search_term: 'Fam'
      expect(assigns(:results)).to eq([family_guy])
    end

    it "redirects to sign in page for unauthenticated users" do
      family_guy = Fabricate(:video, title: 'Family Guy')
      post :search, search_term: 'Fam'
      expect(response).to redirect_to sign_in_path
    end
  end
end