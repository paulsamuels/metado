# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "metado"
require "metado/parser/file"
require "metado/parser/metado"
require "metado/type/comment"
require "metado/type/node"

require "minitest/autorun"
