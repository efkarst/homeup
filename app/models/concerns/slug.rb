module Slug
  module InstanceMethods
    def slug
      self.name.split(" ").join("-").downcase
    end
  end

  module ClassMethods
    def find_by_slug(slug, property)
      self.find_by({property => slug.split("-").join(" ")})
    end
  end

end