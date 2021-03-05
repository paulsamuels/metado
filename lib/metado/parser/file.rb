require_relative "../type/comment"

module Metado
  module Parser
    module File
      class << self
        def comments file
          regex = single_line_comment_regex(file)

          ::File.readlines(file).each_with_index.reduce([[], nil]) { |(comments, current_comment), (line, index)|
            if (line = line[regex, 1])
              (current_comment ||= Type::Comment.new(file, index + 1, []).tap(&comments.method(:push))).body << line
            else
              current_comment = nil
            end

            [comments, current_comment]
          }.first
        end

        private

        def single_line_comment_regex file
          sentinel = case ::File.extname file
          when ".py", ".rb", ".sh"
            "#"
          when ".hs"
            "--"
          else
            "//"
          end

          %r{^\s*#{sentinel}(.*)}
        end
      end
    end
  end
end
