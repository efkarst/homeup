class MyValidator < ActiveModel::Validator
  def validate(record)
    # Add an error if the name chosen is not unqie to the user
    if user_already_has_item_with_name?(record) && user_item_is_not_current_item(record)
      record.errors[:base] << "You already have a #{record.class.name.downcase} named '#{record.name}'"
    end
  end

  # Return true if the user already has an item with that name
  def user_already_has_item_with_name?(record)
    user_item_names(record).include?(record.name.downcase)
  end
  
  # Return array of item names
  def user_item_names(record)
    record.user.send(item_plural(record)).all.collect { |item| item.name }
  end

  # returns true if the item the user is editing is not the one being validated
  def user_item_is_not_current_item(record)
    User.find_by_slug(:username, record.user.slug(:username)).send(item_plural(record)).find_by_slug(:name, record.slug(:name)).id != record.id
  end

  def item_plural(record)
    record.class.name.downcase + 's'
  end
end
