#!/usr/bin/env ruby

# A quick script to download all your files from CloudApp.
# To run this just run the script passing your e-mail & password
# to the script, for example:
#
#    ruby cloudapp-export.rb adam@atechmedia.com mypassword
#

EMAIL_ADDRESS = ARGV[0]
PASSWORD      = ARGV[1]
ROOT          = File.expand_path('../cloudapp-export', __FILE__)
PER_PAGE      = 50

require 'fileutils'
require 'cloudapp_api'
require 'time'

CloudApp.authenticate(EMAIL_ADDRESS, PASSWORD)
FileUtils.mkdir_p(ROOT)
returned_drops = nil
page = 1

somefile = File.open("drops.txt", "w")
until returned_drops && returned_drops < PER_PAGE
  drops = CloudApp::Drop.all(:per_page => PER_PAGE, :page => page)
  puts "Getting Page: #{page}"

  for drop in drops
    somefile.puts drop.content_url
  end
  page += 1
  returned_drops = drops.size
end

somefile.close
