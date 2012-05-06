$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'CarenMotion'
  app.prerendered_icon = true
  app.icons = ['icon.png','icon@2x.png']
  
  # Pods don't seem to work:
  # ISSUE: Using just RestKit fails (Known issue in cocoa pods)
  # ISSUE: Seems buggy with preheaders. I had to manually copy the preheader for 
  #        FileMD5Hash inside the other header file before it would build
  # ISSUE: RestKit does not build
  # ISSUE: Reachability says it yields no .a files and does not continue
  
  app.pods do
    # dependency 'Reachability'
    # dependency 'RestKit/ObjectMapping/XML'
  end
  
  app.vendor_project 'vendor/RestKit', :xcode
  
  app.libs << "/usr/lib/libxml2.dylib"
  
  app.frameworks << 'CFNetwork'
  app.frameworks << 'CoreData'
  app.frameworks << 'Security'
  app.frameworks << 'MobileCoreServices'
  app.frameworks << 'SystemConfiguration'
  app.frameworks << 'QuartzCore'
  
end
