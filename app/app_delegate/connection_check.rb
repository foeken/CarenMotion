module AppDelegate
  module ConnectionCheck
    attr_accessor :internetReachable, :hostReachable
    attr_accessor :internetActive, :hostActive, :connectionActive

    def checkNetworkStatus notice
      @internetActive   = isReachable?(@internetReachable.currentReachabilityStatus)
      @hostActive       = isReachable?(@hostReachable.currentReachabilityStatus)
      @connectionActive = @internetActive && @hostActive

      Notification.post @connectionActive ? "DeviceIsOnlineNotification" : "DeviceIsOfflineNotification"
    end

    def isReachable?(reachabilityStatus)
      case reachabilityStatus
      when NotReachable
        false
      when ReachableViaWiFi, ReachableViaWWAN
        true
      end
    end

    def setupConnectionCheck
      @internetReachable = Reachability.reachabilityForInternetConnection
      @hostReachable     = Reachability.reachabilityWithHostname("www.caren-cares.com")

      @internetReachable.startNotifier
      @hostReachable.startNotifier

      Notification.subscribe "kReachabilityChangedNotification", action:"checkNetworkStatus:", observer:self
    end

  end
end