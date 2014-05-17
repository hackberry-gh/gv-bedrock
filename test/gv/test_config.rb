require 'minitest_helper'
require 'gv/bedrock/config'

GV::Bedrock::Config.const_set "CONFIG_DIR",File.expand_path("../../support",__FILE__)
        
module GV
  module Bedrock
    class TestConfig < Minitest::Test
      
      def setup
        start_server
      end
      
      def stop
        stop_server
      end
      
      def test_discovery
        pid = provide GV::Bedrock::Config
        
        DRb.start_service

        service = GV::Bedrock::Config.service

        refute_nil service
        
        refute_nil service.set("key",  "value")

        assert_equal "value", service.get("key")

        refute_nil service.get("domain")        
        refute_nil service.get("home")
        refute_nil service.get("user")        

        service.clear
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