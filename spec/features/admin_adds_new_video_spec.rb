require 'spec_helper'

feature 'Admin adds a new video' do
  scenario 'Admin successfully adds a new video' do
    admin = Fabricate(:admin)
    drama = Fabricate(:category, name: 'Drama')

    sign_in(admin)
    visit new_admin_video_path

    fill_in('Title', with: 'Spectre')
    select('Drama', from: 'Category')
    fill_in('Description', with: 'Bond, James Bond')
    attach_file('Large cover', 'spec/support/uploads/monk_large.jpg')
    attach_file('Small cover', 'spec/support/uploads/monk.jpg')
    fill_in('Video url', with: 'http://www.example.com/video.mp4')
    click_button('Add Video')

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/tmp/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/video.mp4']")
  end
end