require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    it "returns an empty array when there is no match" do
      futurama = Video.create(title: "Futurama", description: "Pizza boy time traveler")
      family_guy = Video.create(title: "Family Guy", description: "The Griffin family's adventures")
      expect(Video.search_by_title("Underworld")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Pizza boy time traveler")
      family_guy = Video.create(title: "Family Guy", description: "The Griffin family's adventures")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Pizza boy time traveler")
      family_guy = Video.create(title: "Family Guy", description: "The Griffin family's adventures")
      expect(Video.search_by_title("Futur")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Pizza boy time traveler")
      family_guy = Video.create(title: "Family Guy", description: "The Griffin family's adventures", created_at: 1.day.ago)
      modern_family = Video.create(title: "Modern Family", description: "Mockumentary about a modern family")
      expect(Video.search_by_title("Family")).to eq([modern_family, family_guy])
    end

    it "returns and empty array for a search with an empty string" do
      futurama = Video.create(title: "Futurama", description: "Pizza boy time traveler")
      family_guy = Video.create(title: "Family Guy", description: "The Griffin family's adventures")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end