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

  # Pods don't seem to work:
  # ISSUE: Seems buggy with preheaders. I had to manually copy the preheader for
  #        FileMD5Hash inside the other header file before it would build
  # ISSUE: Reachability says it yields no .a files and does not continue

  app.pods do
    pod 'Reachability'
    pod "RestKit"
    pod "KeychainItemWrapper"
  end

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

end
