# frozen_string_literal: true

require "test_helper"
require "tempfile"

module Metado::Parser
  describe File do
    describe "Parsing multiple comments in a single file" do
      it "parses multiple comments from a file" do
        body = [
          "// Comment 1",
          "",
          "",
          "",
          "// Comment 2",
          "// Comment 2",
          "",
          "",
          "",
          "// Comment 3",
          "// Comment 3",
          "// Comment 3"
        ].join("\n")

        make_file("swift", body) do |path|
          assert_equal(
            [
              ::Metado::Type::Comment.new(path, 1, [" Comment 1"]),
              ::Metado::Type::Comment.new(path, 5, [" Comment 2", " Comment 2"]),
              ::Metado::Type::Comment.new(path, 10, [" Comment 3", " Comment 3", " Comment 3"])
            ],
            File.comments(path)
          )
        end
      end
    end

    describe "Handling different languages" do
      it "parses ruby comments" do
        %w[c m mm swift js].each do |extension|
          make_file(extension, language_comments) do |path|
            assert_equal([::Metado::Type::Comment.new(path, 1, [" c style"])], File.comments(path), "Expected '//' to be the comment identifier for extension '.#{extension}'")
          end
        end
      end

      it "parses ruby comments" do
        %w[rb py sh].each do |extension|
          make_file(extension, language_comments) do |path|
            assert_equal([::Metado::Type::Comment.new(path, 2, [" hash"])], File.comments(path), "Expected '#' to be the comment identifier for extension '.#{extension}'")
          end
        end
      end

      it "parses haskell comments" do
        make_file("hs", language_comments) do |path|
          assert_equal([::Metado::Type::Comment.new(path, 3, [" haskell"])], File.comments(path), "Expected '--' to be the comment identifier for extension '.hs'")
        end
      end
    end

    def make_file extension, content, &block
      file = Tempfile.new(["test", ".#{extension}"])
      file.write content
      file.rewind

      block.call(file.path)

      file.close
    end

    def language_comments
      [
        "// c style",
        "# hash",
        "-- haskell"
      ].join("\n")
    end
  end
end
