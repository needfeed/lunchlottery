module Grouper
  def self.make_groups(items)
    groups = []
    until items.empty?
      size = 4
      size = 5 if items.length == 5
      size = 3 if [6, 9].include?(items.length)
      groups << items.slice!(0, size)
    end
    groups
  end
end