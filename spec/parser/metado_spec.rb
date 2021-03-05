# frozen_string_literal: true

require "test_helper"

module Metado::Parser
  describe Metado do
    it "parses a node that contains a title, body and data" do
      body = [
        "METADO: Test title",
        "| Test description",
        "> some = \"assignment\""
      ]

      assert_equal(
        [::Metado::Type::Node.new("file.swift", 5, "Test title", "Test description", {"some" => "assignment"})],
        Metado.parse(::Metado::Type::Comment.new("file.swift", 5, body))
      )
    end

    it "stops parsing when a line doesn't start with | or >" do
      body = [
        "METADO: Test title",
        "some content",
        "| Test description",
        "> some = \"assignment\""
      ]

      assert_equal(
        [::Metado::Type::Node.new("file.swift", 5, "Test title", "", {})],
        Metado.parse(::Metado::Type::Comment.new("file.swift", 5, body))
      )
    end

    it "handles multiple metados in one consecutive comment block" do
      body = [
        "METADO: A",
        "| A description",
        "METADO: B",
        "| B description"
      ]

      assert_equal(
        [::Metado::Type::Node.new("file.swift", 5, "A", "A description", {}), ::Metado::Type::Node.new("file.swift", 7, "B", "B description", {})],
        Metado.parse(::Metado::Type::Comment.new("file.swift", 5, body))
      )
    end
  end
end
