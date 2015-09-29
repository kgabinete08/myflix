require 'spec_helper'

feature 'User resets password' do
  scenario 'user sucessfully resets their password' do
    alice = Fabricate(:user, password: 'old_password')

    visit sign_in_path
    click_link 'Forgot your password?'

    fill_in('Email Address', with: alice.email)
    click_button 'Send Email'

    open_email(alice.email)
    current_email.click_link 'Reset password'

    fill_in('New Password', with: 'new_password')
    click_button 'Reset Password'
    expect(page).to have_content("Your password has been changed.")

    fill_in('Email Address', with: alice.email)
    fill_in('Password', with: 'new_password')
    click_button 'Sign in'
    expect(page).to have_content("You are now signed in!")

    clear_email
  end
end