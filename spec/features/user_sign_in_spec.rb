# require 'rails_helper'
#
# feature "User signs in" do
#   let(:user) { create(:user_home)}
#
#   scenario 'with valid credentials' do
#     visit login_path
#     fill_in "session_email", with: user.email
#     fill_in "session_password", with: "12ab34CD"
#     click_button "Log in"
#
#     expect(page).to have_content(user.name)
#   end
#
#   scenario 'with invalid credentials' do
#     visit login_path
#     fill_in "session_email", with: user.email
#     fill_in "session_password", with: "wrongpassword"
#     click_button "Log in"
#
#     expect(page).to have_content("Email or Password not found")
#   end
# end
