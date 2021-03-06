module StartingBlocks
  module Bash
    def self.run command
      StartingBlocks::Verbose.say "Running: #{command}"
      text      = `#{command}`
      result    = $?
      {
        text:      text,
        success:   result.success?,
        exit_code: result.to_i
      }
    end
  end
end
