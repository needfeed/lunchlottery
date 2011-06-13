module Grouper
  def self.make_groups(items)
    groups = []
    until items.empty?
      size = 4
      size = 3 if [5, 6, 9].include?(items.length)
      groups << items.slice!(0, size)
    end
    groups
  end
end