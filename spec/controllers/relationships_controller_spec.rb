require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "sets @relationships to the current users following relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 2 }
    end

    it "redirects to the people page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship with the current user as follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it "does not create a relationship if the current user is already a follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow a user to follow themself" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      charlie = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end