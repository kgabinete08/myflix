require 'spec_helper'

feature 'User invites a friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_be_following_inviter(alice)
    inviter_should_be_following_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Bob Jones"
    fill_in "Friend's Email Address", with: "bob@example.com"
    fill_in "Message", with: "Join MyFlix bro!"
    click_button "Submit"
    sign_out
  end

  def friend_accepts_invitation
    open_email 'bob@example.com'
    current_email.click_link 'Accept invitation'
    fill_in "Password", with: 'password'
    fill_in "Full Name", with: 'Bob Jones'
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email Address", with: 'bob@example.com'
    fill_in "Password", with: 'password'
    click_button "Sign in"
  end

  def friend_should_be_following_inviter(inviter)
    click_link "People"
    expect(page).to have_content(inviter.full_name)
    sign_out
  end

  def inviter_should_be_following_friend(friend)
    sign_in(friend)
    click_link "People"
    expect(page).to have_content('Bob Jones')
  end
end