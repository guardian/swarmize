#! /usr/bin/env ruby

require 'csv'
require 'fog'
require './fogpatch.rb' # patch for Elastic Beanstalk errors.

# stick your standard Amazon creds in the main project directory.
creds = CSV.read('../credentials.csv', :headers => true)[0]

KEY = creds['Access Key Id']
SECRET = creds['Secret Access Key']

APPNAME = "Swarmize-Mock"
LIVE_ENV = "Swarmize-Mock-Live"
S3_BUCKET = "swarmize-mock"

currentrev = `git log --pretty=format:'%h' -n 1`
package_filename = "package-#{currentrev}.zip"
package_version = "package-#{currentrev}"

s3 = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => KEY,
  :aws_secret_access_key    => SECRET,
  :path_style => true,
  :region => "eu-west-1"
})

beanstalk = Fog::AWS::ElasticBeanstalk.new({
  :aws_access_key_id        => KEY,
  :aws_secret_access_key    => SECRET,
  :region => "eu-west-1",
})

beanstalk_applications = beanstalk.applications
application = beanstalk_applications.find {|a| a.name == APPNAME}

version = nil

if application.version_names.include? package_version
  puts "Version already exists, not packaging code."
  version = application.versions.find {|v| v.label == package_version}
else
  puts "Version does not exist, packaging code."
  puts "Removing old packages"
  system "rm package*.zip"

  Dir.chdir("..") do 
    puts "Archiving website to #{package_filename}"
    system "git archive -o mock-website/#{package_filename} master:mock-website"
  end

  puts "Uploading to S3."

  directory = s3.directories.get(S3_BUCKET)
  file = directory.files.create(
    :key    => "package-#{currentrev}.zip",
    :body   => File.open(package_filename),
    :public => true
  )

  puts "Creating new application version #{package_version}"

  version = application.versions.create(
    :application_name => APPNAME,
    :label => package_version,
    :source_bundle => {"S3Bucket" => S3_BUCKET,
                       "S3Key" => package_filename}
  )
end

live_environment = application.environments.find {|e| e.name == LIVE_ENV }

if live_environment.version_label != package_version
  puts "Creating new application version #{package_version} on environment #{LIVE_ENV}."

  live_environment.version = version
else
  puts "Environment #{LIVE_ENV} already running #{package_version}."
end

