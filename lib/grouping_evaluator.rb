class GroupingEvaluator
  def self.compare(grouping_one, grouping_two)
    hashed_one = GroupingEvaluator.hashify(grouping_one)
    hashed_two = GroupingEvaluator.hashify(grouping_two)

    result = 0
    hashed_one.each_pair do |person, friends|
      result += (hashed_two[person] & friends).size  
    end
    result
  end

  def self.hashify(grouping)
    result = {}
    grouping.each do |group|
      group.each do |person|
        result[person] = group - [person]
      end
    end
    result 
  end

  def self.evaluate(history)
    result = 0
    history.each do |grouping|
      
    end
  end
end