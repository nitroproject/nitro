module Spec
  module Matchers

    class In
      def initialize(collection)
        @collection = collection
      end
      
      def matches?(value)
        @value = value
        return @collection.include?(@value)
      end
      
      def failure_message
        _message
      end
      
      def negative_failure_message
        _message("not ")
      end
      
      def description
        "in #{@collection}"
      end

      private
        def _message(maybe_not="")
          "expected #{@value.inspect} to #{maybe_not}be in #{@collection.inspect}"
        end

    end


    def be_in(collection)
      In.new(collection)
    end
  end
end
