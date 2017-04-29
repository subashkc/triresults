class Placing
	include Mongoid::Document
	attr_accessor :name, :place

	field :name, type: String
	field :place, type: Integer

	def initialize name, place
		@name = name
		@place = place
	end

	def mongoize
		return { :name => @name, :place => @place }
	end

	class << self

		def mongoize placing_obj
			case placing_obj
			when nil then nil
			when Hash then placing_obj
			when self then placing_obj.mongoize
			end
		end

		def demongoize placing_obj
			case placing_obj
			when nil then nil
			when Hash then self.new(placing_obj[:name], placing_obj[:place])
			when self then placing_obj
			end
		end

		def evolve placing_obj
			mongoize placing_obj
		end

	end

end