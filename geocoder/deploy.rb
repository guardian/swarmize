#! /usr/bin/env ruby

require 'csv'
require 'json'
require 'fog'
require 'httparty'

def package(package_filename)
  Dir.chdir("..") do 
    system "git archive -o #{CONFIG['app_dir']}/#{package_filename} master:#{CONFIG['app_dir']}"
  end
end

def notify_slack(version)
  slack_url = "https://swarmize.slack.com/services/hooks/incoming-webhook?token=#{CONFIG['slack_key']}"
  host = CONFIG['host']

  HTTParty.post(slack_url, body: {channel: '#general', username: 'deploybot', text: "Deployed #{CONFIG['appname']} version #{version} to <#{host}>"}.to_json)
end

# stick your standard Amazon creds in the main project directory.
creds = CSV.read('../credentials.csv', :headers => true)[0]

KEY = creds['Access Key Id']
SECRET = creds['Secret Access Key']

CONFIG = JSON.parse(File.read('deploy.json'))

currentrev = `git log --pretty=format:'%h' -n 1`
package_filename = "#{CONFIG['appname'].downcase}-package-#{currentrev}.zip"
package_version = "#{CONFIG['appname'].downcase}-package-#{currentrev}"

s3 = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => KEY,
  :aws_secret_access_key    => SECRET,
  :path_style => true,
  :region => CONFIG['aws_region']
})

beanstalk = Fog::AWS::ElasticBeanstalk.new({
  :aws_access_key_id        => KEY,
  :aws_secret_access_key    => SECRET,
  :region => CONFIG['aws_region']
})

beanstalk_applications = beanstalk.applications
application = beanstalk_applications.find {|a| a.name == CONFIG['appname']}

version = nil

if application.version_names.include? package_version
  puts "Version already exists, not packaging code."
  version = application.versions.find {|v| v.label == package_version}
else
  puts "Version does not exist, packaging code."
  puts "Removing old packages"
  system "rm #{CONFIG['appname'].downcase}-package*.zip"

  puts "Archiving website to #{package_filename}"
  package(package_filename)

  puts "Uploading to S3."

  directory = s3.directories.get(CONFIG['s3_bucket'])
  file = directory.files.create(
    :key    => package_filename,
    :body   => File.open(package_filename),
    :public => true
  )

  puts "Creating new application version #{package_version}"

  version = application.versions.create(
    :application_name => CONFIG['appname'],
    :label => package_version,
    :source_bundle => {"S3Bucket" => CONFIG['s3_bucket'],
                       "S3Key" => package_filename}
  )

end

live_environment = application.environments.find {|e| e.name == CONFIG['live_env'] }

if live_environment.version_label != package_version
  puts "Creating new application version #{package_version} on environment #{CONFIG['live_env']}."

  live_environment.version = version
  if CONFIG['slack_key']
    notify_slack(package_version)
  end
else
  puts "Environment #{CONFIG['live_env']} already running #{package_version}."
end

