#! /usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'json'
require 'httparty'
require 'aws-sdk'



def package(directory, package_filename)
  Dir.chdir(directory) do
    unless system("./package.sh", package_filename, directory)
      fail "package failed"
    end
  end
end

def notify_slack(version)
#  slack_url = "https://swarmize.slack.com/services/hooks/incoming-webhook?token=#{config_value('slack_key')}"
# TODO
#  host = CONFIG['host']

#  HTTParty.post(slack_url, body: {channel: '#general', username: 'deploybot', text: "Deployed #{CONFIG['appname']} version #{version} to <#{host}>"}.to_json)
end

def fail(message)
  puts "failed: #{message}"
  exit(status = false)
end



if ARGV.size != 1
  apps = Dir["*/eb_name.txt"].map { |path| File.dirname(path) }
  fail "usage: deploy #{apps.join("|")}"
end

app_dir_name = ARGV[0]
app_dir = app_dir_name

beanstalk_app_name = File.read("#{app_dir}/eb_name.txt").strip
s3bucket = ENV["S3_BUCKET"]


currentrev = `git log --pretty=format:'%h' -n 1`

package_name = "rev-#{currentrev}.zip"
package_path = "#{app_dir_name}/#{package_name}"
package_version = "rev-#{currentrev}"

puts "deploy #{beanstalk_app_name} #{package_version}"

s3 = AWS::S3.new
elasticbeanstalk = AWS::ElasticBeanstalk::Client.new

vers = elasticbeanstalk.describe_application_versions( {application_name: beanstalk_app_name} )

this_version = vers.application_versions.find { |v| v.version_label == package_version }

if this_version
  puts " version is already created"
else
  puts " packaging..."

  package(app_dir, package_name)

  puts " uploading to S3..."
  bucket = s3.buckets[s3bucket]

  bucket.objects[package_path].write(Pathname.new(package_path))

  puts " creating application version #{package_version}..."

  elasticbeanstalk.create_application_version({
          application_name: beanstalk_app_name,
          source_bundle: { s3_bucket: s3bucket, s3_key: package_path },
          version_label: package_version
  })
end



envs = elasticbeanstalk.describe_environments({application_name: beanstalk_app_name})[:environments]

if envs.size == 0
  fail "no environments found for #{beanstalk_app_name}, cannot make this version live"
elsif envs.size != 1
  env_string = envs.map {|e| e[:cname] }.join(", ")
  fail "found multiple enviroments for #{beanstalk_app_name} (#{env_string}), cannot make this version live"
else
  env = envs.first
  environment_id = env[:environment_id]

  puts " deploying to environment #{env[:environment_name]} (#{env[:cname]})"

  result = elasticbeanstalk.update_environment ({
      environment_id: environment_id,
      version_label: package_version })

  request_id = result[:response_metadata][:request_id]
end

last_status = nil
seen_events = []

begin

  sleep 5

  events = elasticbeanstalk.describe_events({request_id: request_id})

  event_strings = events[:events].map { |e| "#{e[:event_date]} #{e[:severity]}: #{e[:message]}"}

  this_env = elasticbeanstalk.describe_environments({environment_ids: [ environment_id ] })[:environments]
  status = this_env.first[:status]


  if status != last_status
    puts "Status is #{status}"
    last_status = status
  end

  event_strings.each {|e|
    unless seen_events.include?(e)
      puts e
      seen_events << e
    end
  }


end until status == "Ready"






