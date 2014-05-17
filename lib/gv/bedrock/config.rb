require 'gv/bedrock/service'
require 'gv/common/host_helper'

module GV
  module Bedrock
  
    ##
    # Etcd Client Service
    #
  
    class Config < Service
      
      CONFIG_DIR = "/etc/greenvalley/config"
      
      include GV::Common::HostHelper      

      def initialize
        super
        
        # set tuple space as api
        @api = self.class.space
        
        # set default config values
        # by reading files in CONFIG_DIR
        # likely created on server setup
        Dir.glob("#{CONFIG_DIR}/*").each do |config_file|
          key = File.basename(config_file)
          value = (File.read(config_file).chomp rescue nil)          
          set key,value
        end

      end
      
      # non blocking tuple reading 
      def get key
        @api.read([:config,key,nil],0)[2] rescue nil
      end
      
      def set key, value
        @api.write([:config,key,value])
      end
      
      def rem key
        @api.take([:config,key,nil],0) rescue nil
      end
      
      def clear
       rem(nil) while get(nil)
      end
      
    end
    
  end
end