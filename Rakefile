$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require "rubygems"
require "bundler"
Bundler.require

Motion::Project::App.setup do |app|

  pixate_settings = YAML.load(File.open("pixate.yml"))

  # Use `rake config' to see complete project settings.
  app.name = 'CarenMotion'
  app.prerendered_icon = true
  app.icons = ['icon.png','icon@2x.png']
  app.detect_dependencies = false
  app.deployment_target = '6.0'
  # app.pixate.user = pixate_settings[:user]
  # app.pixate.key = pixate_settings[:key]
  # app.pixate.framework = 'vendor/PXEngine.framework'

  app.pods do
    pod "Reachability"
    pod "KeychainItemWrapper"
    pod "SVProgressHUD"
    pod "AFNetworking"
    pod "AFXAuthClient"
    pod "AFKissXMLRequestOperation"
  end

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

end
