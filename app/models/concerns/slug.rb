module Slug
  module InstanceMethods
    def slug(property)
      self[property].split(" ").join("-").downcase
    end
  end

  module ClassMethods
    def find_by_slug(property, slug)
      self.find_by({property => slug.split("-").join(" ")})
    end
  end

end