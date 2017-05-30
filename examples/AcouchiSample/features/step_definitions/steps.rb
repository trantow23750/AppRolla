When /^I write the text "(.*?)"$/ do |text|
  page.enter_text text
end

When /^I clear the text$/ do
  page.clear_text
end

Then /^I see "(.*?)"$/ do |text|
  page.should have_text text
end

Then /^I do not see "(.*?)"$/ do |text|
  page.should_not have_text text
end

Then /^I see one button$/ do
  page.buttons.size.should == 1
end

Then /^it has the text "(.*?)"$/ do |text|
  page.should have_button text
end

When /^I click the text "(.*?)"$/ do |text|
  page.click_text(text)
end

Then /^I see the content "(.*?)"$/ do |content|
  page.should have_content content
end

Then /^I see all views$/ do
  p page.views
end

Then /^I see text views$/ do
  p page.text_views
end

Then /^I see all content$/ do
  p page.all_content
end
