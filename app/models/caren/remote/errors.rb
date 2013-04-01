module Caren
  module Remote

    class Error
      attr_reader :message

      def initialize message
        @message = message
      end

      def to_s
        @message
      end
    end

    class ValidationError < Error
      attr_reader :field

      def initialize field, message
        @field = field.to_sym
        super(message)
      end

      def to_s
        "#{@field.capitalize} #{@message}"
      end
    end

  end
end