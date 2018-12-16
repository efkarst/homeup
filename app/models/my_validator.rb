class MyValidator < ActiveModel::Validator
  def validate(record)
    if user_item_names(record).include?(record.name.downcase) && User.find_by_slug(:username, record.user.slug(:username)).send(item_plural(record)).find_by_slug(:name, record.slug(:name)).id != record.id
      record.errors[:base] << "You already have a #{record.class.name.downcase} named '#{record.name}'"
    end
  end

  def user_item_names(record)
    record.user.send(item_plural(record)).all.collect { |item| item.name }
  end

  def item_plural(record)
    record.class.name.downcase + 's'
  end
end
