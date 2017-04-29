class Address
	include Mongoid::Document
	attr_accessor :city, :state, :location

	field :city, type: String
	field :state, type: String
	field :loc, as: :location, type: Point

	def initialize city=false, state=false, location=false
		super()
		@city = city || ''
		@state = state || ''
		@location = location || ''
	end

	def mongoize
		{ :city => @city, :state => @state, :loc => Point.mongoize(@location) }
	end

	class << self

		def mongoize address_obj
			case address_obj
			when nil then nil
			when Hash then address_obj
			when self then address_obj.mongoize
			end
		end

		def demongoize address_obj
			case address_obj
			when nil then nil
			when Hash then self.new(address_obj[:city], address_obj[:state], Point.demongoize(address_obj[:loc]))
			when self then address_obj
			end
		end

		def evolve address_obj
			mongoize address_obj
		end

	end

end