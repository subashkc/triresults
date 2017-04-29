class Point
	include Mongoid::Document
	attr_accessor :longitude, :latitude

	field :latitude
	field :longitude


	def initialize longitude, latitude
		@longitude = longitude
		@latitude = latitude
	end

	def mongoize
		return { :type => "Point", :coordinates => [@longitude, @latitude] }
	end

	class << self

		def mongoize point_obj
			case point_obj
			when nil then nil
			when Hash then point_obj
			when self then point_obj.mongoize
			end
		end

		def demongoize point_obj
			case point_obj
			when nil then nil
			when Hash then self.new(point_obj[:coordinates][0], point_obj[:coordinates][1])
			when self then point_obj
			end
		end

		def evolve point_obj
			mongoize point_obj
		end

	end

end