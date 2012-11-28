module AppDelegate
  module Keyboard

    attr_accessor :keyboardVisible, :keyboardBounds, :keyboardAnimationDuration, :keyboardAnimationCurve

    def setupKeyboard
      Notification.subscribe UIKeyboardDidHideNotification, action:"keyboardHide", observer:self
      Notification.subscribe UIKeyboardWillShowNotification, action:"keyboardShow:", observer:self
    end

    def keyboardShow notification
      @keyboardVisible = true
      @keyboardBounds = notification.userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue
      @keyboardAnimationDuration = notification.userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey)
      @keyboardAnimationCurve = notification.userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey)
    end

    def keyboardHide
      @keyboardVisible = false
      @keyboardBounds = nil
      @keyboardAnimationDuration = nil
      @keyboardAnimationCurve = nil
    end

  end
end