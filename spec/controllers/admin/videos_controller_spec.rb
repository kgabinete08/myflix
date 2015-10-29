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
      before { set_current_admin }
      let(:category) { Fabricate(:category) }

      it "redirects to the add new video page" do
        post :create, video: { title: "Ghostbusters", description: "Who you gonna call?", category_id: category.id }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates the video" do
        post :create, video: { title: "Ghostbusters", description: "Who you gonna call?", category_id: category.id }
        expect(category.videos.count).to eq(1)
      end

      it "sets the flash success message" do
        post :create, video: { title: "Ghostbusters", description: "Who you gonna call?", category_id: category.id }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before { set_current_admin }
      let(:category) { Fabricate(:category) }

      it "does not create a video" do
        post :create, video: { title: "Ghostbusters", category_id: category.id }
        expect(category.videos.count).to eq(0)
      end

      it "renders the new template" do
        post :create, video: { title: "Ghostbusters", category_id: category.id }
        expect(response).to render_template :new
      end

      it "sets @video" do
        post :create, video: { title: "Ghostbusters", category_id: category.id }
        expect(assigns(:video)).to be_present
      end

      it "sets the flash danger message" do
        post :create, video: { title: "Ghostbusters", category_id: category.id }
        expect(flash[:danger]).to be_present
      end
    end
  end
end