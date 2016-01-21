require 'spec_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, full_name: "Alice Wunder", email: "alice@abc.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Wunder")
    expect(page).to have_content("alice@abc.com")
  end

  scenario "regular user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Wunder")
    expect(page).to have_content("Authorized users only.")
  end
end
