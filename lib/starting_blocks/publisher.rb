module StartingBlocks
  module Publisher
    class << self
      attr_accessor :subscribers

      def publish results
        return unless @subscribers
        @subscribers.each { |s| s.receive results }
      end
    end
  end
end
StartingBlocks::Publisher.subscribers = []
