require 'drb'
require 'rinda/ring'
require 'active_support/inflector'

module GV
  module Bedrock
  
    ##
    # Base class of distributed services
    #
  
    class Service
    
      include DRb::DRbUndumped

      class << self
        
        ##
        # advertises service into primary tuple space
        
        def provide
          DRb.start_service
          provider.provide
          info "Service #{self.name} started on #{DRb.uri}"
          DRb.thread.join
        end
      
        ##
        # Default Service Provider
        
        def provider
          @@provider ||= Rinda::RingProvider.new(self.name.underscore,self,self.new,nil)
        end
        
        ##
        # Retrives service instance
        
        def service
          self.find self.name.underscore
        end
        
        ##
        # Retrives random service instance
        
        def random_service
          services.sample
        end
        
        ##
        # Retrives all service instances
        
        def services
          space.read_all([:name,self.name.underscore,nil,nil]).map{|s| s[3]} rescue []
        end
        
        ##
        # Finds previously provided service, blocks if there isn't any
        
        def find name
          space.read([:name,name,nil,nil])[3] rescue nil
        end      
      
        ##
        # Primary remote tuple space
        
        def space
          @@space ||= Rinda::TupleSpaceProxy.new(Rinda::RingFinger.primary)
        end
        
      end
      
      def method_missing name, *args, &block
        if @api.respond_to? name
          @api.public_send name, *args, &block
        else
          super name, *args, &block
        end
      end
      
    end
    
  end
end