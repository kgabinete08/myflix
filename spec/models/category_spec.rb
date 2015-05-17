require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    it "returns an empty array if there are no videos in a category" do
      drama = Category.create(name: "Drama")
      expect(drama.recent_videos).to eq([])
    end

    it "returns the videos in reverse chronological order by created_at" do
      drama = Category.create(name: "Drama")
      ghostbusters = Video.create(title: "Ghostbusters", description: "Who you gonna call?", category: drama, created_at: 1.day.ago)
      archer = Video.create(title: "Archer", description: "A spy show", category: drama)
      expect(drama.recent_videos).to eq([archer, ghostbusters])
    end

    it "returns all videos if there are less than 6 videos in a category" do
      drama = Category.create(name: "Drama")
      ghostbusters = Video.create(title: "Ghostbusters", description: "Who you gonna call?", category: drama, created_at: 1.day.ago)
      archer = Video.create(title: "Archer", description: "A spy show", category: drama)
      sherlock = Video.create(title: "Sherlock", description: "Fantastic show", category: drama)
      expect(drama.recent_videos.count).to eq(3)
    end

    it "returns 6 videos if there are more than 6 videos in a category" do
      drama = Category.create(name: "Drama")
      7.times { Video.create(title: "Ghostbusters", description: "Who you gonna call?", category: drama) }
      expect(drama.recent_videos.count).to eq(6)
    end

    it "return the 6 most recent videos" do
      drama = Category.create(name: "Drama")
      6.times { Video.create(title: "Ghostbusters", description: "Who you gonna call?", category: drama) }
      ghostbusters = Video.create(title: "Ghostbusters", description: "Who you gonna call?", category: drama, created_at: 1.day.ago)
      expect(drama.recent_videos).not_to include(ghostbusters)
    end
  end
end