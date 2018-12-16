class MyValidator < ActiveModel::Validator
  def validate(record)
    if user_already_has_item_with_name?(record) && user_item_is_not_current_item(record)
      record.errors[:base] << "You already have a #{record.class.name.downcase} named '#{record.name}'"
    end
  end

  def user_already_has_item_with_name?(record)
    user_item_names(record).include?(record.name.downcase)
  end

  def user_item_names(record)
    record.user.send(item_plural(record)).all.collect { |item| item.name }
  end

  def user_item_is_not_current_item(record)
    User.find_by_slug(:username, record.user.slug(:username)).send(item_plural(record)).find_by_slug(:name, record.slug(:name)).id != record.id
  end

  def item_plural(record)
    record.class.name.downcase + 's'
  end
end
