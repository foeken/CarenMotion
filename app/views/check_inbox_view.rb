class CheckInboxView < DefaultView

  stylesheet :checkInboxView

  attr_accessor :envelope

  def render
    @person = Caren::Person.where("me = %@",true).first

    @envelope = subview(UIImageView, :envelope)
    @title = subview(UILabel, :title, text: _("Check your inbox for our mail."))
    @body = subview(UILabel, :body, text: _("We’ve sent you an email with an activation link. Tap the link in the mail to continue or tap refresh if you already activated your account elsewhere.\n\nDid not receive any mail yet?\nTap try again, but give it a few minutes...") )
  end

  def animateEnvelope
    @envelope.shake offset: 0.1, repeat: 2, duration: 0.5, keypath: 'transform.rotation'
    3.second.every do
      @envelope.shake offset: 0.1, repeat: 2, duration: 0.5, keypath: 'transform.rotation'
    end
  end

end