module Slug
  module InstanceMethods
    # Instance method to get the slug for an object property
    def slug(property)
      self[property].split(" ").join("-").downcase
    end
  end

  module ClassMethods
    # Class method to find an object based on the slug of a property
    def find_by_slug(property, slug)
      self.find_by({property => slug.split("-").join(" ")})
    end
  end

end