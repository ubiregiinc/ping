require "bundler/setup"
require 'webmock/minitest'
require 'rr'
require 'unification_assertion'
require 'rack/test'

require 'app'

MiniTest.autorun

class TestCase < MiniTest::Test
  include UnificationAssertion
end
