require 'minitest'
require 'webmock/minitest'
require 'rr'
require 'unification_assertion'
require 'rack/test'

require File.expand_path('app')

MiniTest.autorun

class TestCase < MiniTest::Test
  include UnificationAssertion
end
