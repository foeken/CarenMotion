module AppDelegate
  module ConnectionCheck  
    attr_accessor :internetReachable, :hostReachable
    attr_accessor :internetActive, :hostActive, :connectionActive
  
    # Check if the internet is reachable. Also does a check if our host is available.
    def setupConnectionCheck
      
      # ISSUE: Reachability does not compile
      @internetActive = true
      @hostActive = true
      @connectionActive = true
      return
      
      @internetReachable = Reachability.reachabilityForInternetConnection
      @internetReachable.startNotifier
    
      @hostReachable = Reachability.reachabilityWithHostName("www.caren-cares.com")
      @hostReachable.startNotifier
        
      NSNotificationCenter.defaultCenter.addObserver self, 
                                                     selector:"checkNetworkStatus",
                                                     name:kReachabilityChangedNotification,
                                                     object:nil
    end
  
    def checkNetworkStatus notice
      case @internetReachable.currentReachabilityStatus
      when NotReachable
        @internetActive = false
      when ReachableViaWiFi, ReachableViaWWAN
        @internetActive = true
      end
    
      case @hostReachable.currentReachabilityStatus
      when NotReachable
        @hostActive = false
      when ReachableViaWiFi, ReachableViaWWAN
        @hostActive = true
      end
    
      @connectionActive = @internetActive && @hostActive
    
      if @connectionActive
        NSNotificationCenter.defaultCenter.postNotificationName("DeviceIsOnline", object:nil)
      else
        NSNotificationCenter.defaultCenter.postNotificationName("DeviceIsOffline", object:nil)
      end
    end  
  end
end