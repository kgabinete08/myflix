require 'spec_helper'

feature 'User interacts with the queue' do
  scenario 'user adds and reorders videos in the queue' do
    action      = Fabricate(:category)
    mad_max     = Fabricate(:video, title: "Mad Max", category: action)
    scarface    = Fabricate(:video, title: "Scarface", category: action)
    transporter = Fabricate(:video, title: "Transporter", category: action)

    sign_in

    add_video_to_queue(mad_max)
    expect_video_to_be_in_queue(mad_max)

    visit video_path(mad_max)
    expect_link_not_to_be_visible("+ My Queue")

    add_video_to_queue(scarface)
    add_video_to_queue(transporter)

    set_video_position(mad_max, 3)
    set_video_position(scarface, 1)
    set_video_position(transporter, 2)

    update_queue

    expect_video_position(scarface, 1)
    expect_video_position(transporter, 2)
    expect_video_position(mad_max, 3)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_visible(link_text)
    expect(page).not_to have_content(link_text)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end