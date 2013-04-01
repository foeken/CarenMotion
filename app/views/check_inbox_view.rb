class CheckInboxView < DefaultView

  stylesheet :checkInboxView

  def render
    @person = Caren::Person.where("me = %@",true).first

    @envelop = subview(UIImageView, :envelop)
    @title = subview(UILabel, :title, text: _("Check your inbox for our mail."))
    @body = subview(UILabel, :body, text: _("We’ve sent you an email with an activation link. Tap the link in the mail to continue or tap refresh if you already activated your account elsewhere.\n\nDid not receive any mail yet?\nTap try again, but give it a few minutes...") )
  end

end