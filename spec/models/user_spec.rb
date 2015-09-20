require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it "generates a random token when a user is created" do
    alice = Fabricate(:user)
    expect(alice.token).to be_present
  end

  describe "#queued_video?" do
    let(:user) { user = Fabricate(:user) }
    let(:video) { video = Fabricate(:video) }

    it "returns true when the user has the video in queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end

    it "returns false when the user does not have the video in queue" do
      expect(user.queued_video?(video)).to be false
    end
  end

  describe "#already_follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.already_follows?(bob)).to be true
    end

    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.already_follows?(bob)).to be false
    end
  end
end