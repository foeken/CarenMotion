$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require "rubygems"
require "bundler"
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CarenMotion'
  app.prerendered_icon = true
  app.icons = ['icon.png','icon@2x.png']
  app.detect_dependencies = false
  app.deployment_target = '6.0'

  app.pods do
    pod "Reachability"
    pod "RestKit/XML"
    pod "KeychainItemWrapper"
    pod "SVProgressHUD"
  end

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

end
