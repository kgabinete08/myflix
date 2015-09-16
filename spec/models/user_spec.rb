require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe "#queued_video?" do
    let(:user) { user = Fabricate(:user) }
    let(:video) { video = Fabricate(:video) }

    it "returns true when the user has the video in queue" do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "returns false when the user does not have the video in queue" do
      expect(user.queued_video?(video)).to be_falsey
    end
  end
end