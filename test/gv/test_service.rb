require 'minitest_helper'

module GV
  module Bedrock
    class TestService < Minitest::Test
      
      def setup
        start_server
      end
      
      def stop
        stop_server
      end
      
      def test_discovery
        pid = provide GV::Bedrock::Service
        
        DRb.start_service
        
        refute_nil GV::Bedrock::Service.find("gv/bedrock/service")
        
        # clear all services
        GV::Bedrock::Service.space.read_all([nil,nil,nil,nil]).each do |t|
          GV::Bedrock::Service.space.take(t)
        end
        
        DRb.stop_service
        
        kll pid
        
      end
      
    end
  end
end