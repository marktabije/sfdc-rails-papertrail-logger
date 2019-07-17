require 'restforce'
require 'faye'
require 'fileutils'

# Initialize a client with your username/password.
client = Restforce.new :username => ENV['SFDC_USERNAME'],
  :password       => ENV['SFDC_PASSWORD'],
  :security_token => ENV['SFDC_SECURITY_TOKEN'],
  :client_id      => ENV['SFDC_CLIENT_ID'],
  :client_secret  => ENV['SFDC_CLIENT_SECRET'],
	:host				    => 'test.salesforce.com',
	:api_version    =>  '41.0'

# simply for debugging
puts client.to_yaml

begin

	client.authenticate!
	puts 'Successfully authenticated to salesforce.com'

	EM.next_tick do
	  client.subscribe 'LogEntries' do |message|
			puts "[#{message['sobject']['Level__c']}] #{message['sobject']['Class__c']} - #{message['sobject']['Short_Message__c']} (#{message['sobject']['Name']})"
	  end
	end

rescue
  puts "Could not authenticate. Not listening for streaming events."
end

FileUtils.mv('/app/salesforce/cookie_validation.rb', '/app/vendor/bundle/ruby/2.5.0/gems/cookiejar-0.3.3/lib/cookiejar')