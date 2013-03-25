module Caren
  class Base

    def self.key(*vars)
      @keys ||= []
      @keys.concat vars
    end

    def self.keys
      @keys
    end

  end
end
