class Event
  include Mongoid::Document

  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  validates_presence_of :order, :name

  embedded_in :parent, polymorphic: true, touch: true

  def meters
  	return nil unless self.distance.to_f > 0
  	case self.units
  	when 'miles' then 1609.344 * self.distance
  	when 'kilometers' then  1000 * self.distance
  	when 'yards' then 0.9144 * self.distance
  	when 'meters' then self.distance
  	end
  end

  def miles
  	return nil unless self.distance.to_f > 0
  	case self.units
  	when 'meters' then 0.000621371 * self.distance
  	when 'kilometers' then  0.621371 * self.distance
  	when 'yards' then 0.000568182 * self.distance
  	when 'miles' then self.distance
  	end
  end

end
