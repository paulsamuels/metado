require "tomlrb"
require_relative "../type/node"

module Metado
  module Parser
    module Metado
      def self.parse comment
        comment.body.each_with_index.reduce([[], nil]) { |(metados, current_metado), (line, index)|
          if (title = line[/^\s*METADO:\s*(.*)/, 1])
            current_metado = Type::Node.new(comment.file, comment.line_number + index, title, [], []).tap(&metados.method(:push))
          elsif current_metado
            if (body = line[/^\s*\|\s*(.*)/, 1])
              current_metado.body << body
            elsif (data = line[/^\s*>\s*(.*)/, 1])
              current_metado.data << data
            else
              current_metado = nil
            end
          else
            current_metado = nil
          end

          [metados, current_metado]
        }.first.map { |item|
          Type::Node.new(item.file, item.line_number, item.title, item.body.join("\n"), Tomlrb.parse(item.data.join("\n")))
        }
      end
    end
  end
end
