module Caren
  module Remote
    class Person < Proxy

      def activate session, id, code, &block
        session.post activationPath(id), xmlForCode(code), successCallback(block), failureCallback(block)
      end

      def forgotPassword session, email, &block
        person = Caren::Person.new
        person.email = email
        session.post forgotPasswordPath, person.toXml, successCallback(block), failureCallback(block)
      end

      def xmlForCode code
        DDXMLDocument.alloc.initWithXMLString("<code>#{code}</code>", options:0, error:nil).XMLData
      end

      def activationPath id
        "#{resourcePath(id)}/activate"
      end

      def forgotPasswordPath
        "api/forgot_password"
      end

    end
  end
end