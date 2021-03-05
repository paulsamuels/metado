require_relative "parser/file"
require_relative "parser/metado"

require "json"

module Metado
  class CLI
    def self.start
      unless (dir = ARGV.first)
        puts "Usage: metado SOURCE_DIR"
        exit 1
      end

      result = Dir["#{dir}/**/*"].flat_map do |file|
        next unless File.file?(file)

        Parser::File.comments(file).map(&Parser::Metado.method(:parse)).flatten.map(&:to_h)
      end.compact

      puts JSON.generate result
    end
  end
end
