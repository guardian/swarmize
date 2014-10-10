class PermissionMailer < ActionMailer::Base
  default from: "noreply@swarmize.com",
          reply_to: 'graham.tackley@guardian.co.uk',
          return_path: 'graham.tackley@guardian.co.uk'

  def permission_email(to_address, swarm)
    @swarm = swarm
    mail(to: to_address, subject: "[Swarmize] You've been given permissions on a Swarm.")
  end
end
