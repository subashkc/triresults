class BikeResult < LegResult

	field :mph, as: :mph, type: Float

	def calc_ave
		if event && secs
			miles = event.miles
			self.mph = miles.nil? ? nil : miles / ( secs / 3600 )
		end
	end

end