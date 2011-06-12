require 'spec_helper'

describe DailyCron do
  describe ".work" do
    it "sends reminders on sunday" do
      Person.should_not_receive(:send_reminders)
      Timecop.freeze(Date.civil(2011, 5, 8)) do
        DailyCron.work
      end
    end

    it "sends invitations on monday" do
      Person.should_not_receive(:send_invitations)
      Timecop.freeze(Date.civil(2011, 5, 9)) do
        DailyCron.work
      end
    end
  end
end