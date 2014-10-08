require 'rspec'
# require 'watir'
require 'watir-webdriver'

$: << File.dirname(__FILE__)+'/.'
require 'helpers.rb'
require 'VendorTestAd.rb'

browser = Watir::Browser.new #:phantomjs

if ARGV.length > 1
	URL_BASE = ARGV[2]
else
	URL_BASE = "http://localhost:9099"
end

TESTPAGE_PATH = "/tests/automation/integration_watir/test_pages/"

def testpage_url(page)
	return URL_BASE + TESTPAGE_PATH + page
end

puts "================== \033[1;32mBEGIN SAFEFRAME TESTS\033[0m ===================="
puts "\033[1;36m" + URL_BASE + "\033[0m\n"
puts testpage_url "external_methods_test.html"

RSpec.configure do |config|
  config.include Helpers
  # config.include VendorTestAd
  
  config.before(:each) { 
  }
  config.before(:suite) {
	# browser.goto(logout_url)
    
	#login
	b = browser
	#b.text_field(:id => 'UserName').set user_name
	#b.text_field(:id => 'Password').set user_pass
	
	#b.checkbox(:id => 'RememberMe').clear
	#b.button(:type => 'submit').click
	
  }
  
  config.after(:suite) { browser.close unless browser.nil? }

end

describe "an integration test of SafeFrame" do
  # include Helpers
  # include VendorTestAd
  
  browser.goto(testpage_url "external_methods_test.html")
  
  describe "that we start on external methods test page" do
	ad = VendorTestAd.new(browser, 'tgtLREC2')
		
	before(:each) do
		
	end
	  
    it "should be on external methods test" do
      browser.text.should include('External method tests')
    end
	
	it "should clear ad log" do
		b = browser
		ad.log_text.should include('META-CONTENT initialized')
		ad.clear_log
		ad.log_text.should_not include('META-CONTENT initialized')
	end
	
	it "should not have an Error" do
		b = browser
		b.text.should_not include('Error')
	end
	
	it "should support overlay expansion" do
		supports = ad.supports_output
		supports.should include("exp-ovr: 1");
		supports.should include("exp-push: 0");
	end
	
	it "should have geometry data" do
		geom = ad.geom_output
		geom.should_not include("Geometry missing");
		geom.should include("win");
		geom.should include("par");
		geom.should include("self");
	end
	
	it "should report correct ad width in geom" do
		geom = ad.geom_output
		geom.should_not include("Geometry missing");
		geom.should include("self");
		geom.should include("w: 400, h: 450");
	end
  end

end
