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
        
      Notification.subscribe kReachabilityChangedNotification, action:"checkNetworkStatus", observer:self
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
        Notification.post "DeviceIsOnlineNotification"
      else
        Notification.post "DeviceIsOfflineNotification"
      end
    end  
  end
end