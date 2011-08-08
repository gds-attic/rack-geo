require 'capybara'
require 'capybara/dsl'
require 'rack/geo'
require './councils.rb'
require 'test/unit'

class HelloWorldTest < Test::Unit::TestCase
  include Capybara::DSL
  Capybara.default_driver = :selenium # <-- use Selenium driver

  def setup
    Capybara.app = Rack::Builder.app do
      use Rack::Geo
      run Sinatra::Application.new
    end
    Capybara.default_wait_time = 5
  end

  def test_clicky_clicky
    visit '/'
    
    click_link 'Set location'
    fill_in 'postcode', :with => "SE10 8UG"
    click_button "Go"
    
    assert page.has_content?("Greenwich")
    
    click_link 'Change location'
    click_link 'Forget my location'
    
    assert ! page.has_content?("Greenwich")
    
    click_link 'Set location'
    fill_in 'postcode', :with => "SE10 8UG"
    click_button "Go"
    
    assert page.has_content?("Greenwich")
    click_link 'Change location'
    fill_in 'postcode', :with => "CF46 6PG"
    click_button "Go"
    
    assert page.has_content?("Caerphilly")
  end
end