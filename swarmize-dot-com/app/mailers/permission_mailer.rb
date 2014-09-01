class PermissionMailer < ActionMailer::Base
  default from: "tom@infovore.org" # TODO not forever, please

  def permission_email(to_address, swarm)
    @swarm = swarm
    mail(to: to_address, subject: "[Swarmize] You've been given permissions on a Swarm.")
  end
end
