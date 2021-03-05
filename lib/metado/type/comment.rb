module Metado
  module Type
    Comment = Struct.new(:file, :line_number, :body)
  end
end
