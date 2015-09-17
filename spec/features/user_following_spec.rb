require 'spec_helper'

feature "User following" do
  scenario "user follows and unfollows another user" do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: alice, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link alice.full_name
    click_link "Follow"
    expect_to_follow_user(alice)

    unfollow(alice)
    expect_to_unfollow_user(alice)
  end

  def expect_to_follow_user(user)
    expect(page).to have_content(user.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end

  def expect_to_unfollow_user(user)
    expect(page).not_to have_content(user.full_name)
  end
end