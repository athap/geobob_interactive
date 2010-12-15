When /^I log in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  visit(new_user_session_path)
  fill_in("user[email]", :with => email)
  fill_in("user[password]", :with => password)
  click_button("Sign in")
end

Given /^a logged in admin user$/ do
  Factory.create(:admin)
  visit(new_user_session_path)
  fill_in("user[email]", :with => "quickleft@quickleft.com")
  fill_in("user[password]", :with => "password")
  click_button("Sign in")
end

Given /^a logged in member user$/ do
  Factory.create(:member)
  visit(new_user_session_path)
  fill_in("user[email]", :with => "member@quickleft.com")
  fill_in("user[password]", :with => "password")
  click_button("Sign in")
end

When /^I log out$/ do
  visit(destroy_user_session_path)
end

Given /^a user "([^\"]*)"$/ do |email|
  Factory.create(:user, :email => email)
end
