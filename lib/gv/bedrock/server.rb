require 'gv/bedrock'
require 'drb'
require 'rinda/ring'
require 'rinda/tuplespace'

module GV
  module Bedrock
    class Server
      
      def self.provide
        server = new
        server.start
      end
      
      def start
        
        $SAFE = 1
        
        DRb.start_service

        begin
          @ts = Rinda::TupleSpace.new
          @rs = Rinda::RingServer.new(@ts)
          info "#{self.class.name} started on #{DRb.uri}"
          DRb.thread.join  
        rescue Errno::EADDRINUSE => e
          error e.inspect
        ensure
          DRb.stop_service           
        end
        
      end
  
    end
  end
end