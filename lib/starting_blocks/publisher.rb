module StartingBlocks
  module Publisher
    class << self
      attr_accessor :subscribers

      def publish_results results
        return unless @subscribers
        @subscribers.each { |s| s.receive_results results }
      end
    end
  end
end
StartingBlocks::Publisher.subscribers = []