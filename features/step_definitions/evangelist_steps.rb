Then(/^NuWe receives an email notification$/) do
  expect(ActionMailer::Base.deliveries.map{|email|email.to.first}).to include("tech@nuwe.co")
end

When(/^I click Submit$/) do
  page.execute_script("$('.contact_form').submit();")
  Timeout.timeout(Capybara.default_wait_time) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end
