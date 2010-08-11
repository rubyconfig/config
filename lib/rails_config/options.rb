require 'ostruct'
module RailsConfig
  class Options < OpenStruct
    def empty?
      marshal_dump.empty?
    end
  end
end