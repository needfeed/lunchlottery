require 'spec_helper'

describe DailyCron do
  describe ".work" do
    it "sends reminders on sunday" do
      Person.should_receive(:send_reminders)
      work_on_day_in_may(8)
    end

    it "sends invitations on monday" do
      Person.should_receive(:send_invitations)
      work_on_day_in_may(9)
    end

    (10..14).each do |day|
      it "sends no other messages" do
        work_on_day_in_may(day)
        ActionMailer::Base.deliveries.should be_empty
      end
    end
  end

  def work_on_day_in_may(day)
    date = Date.civil(2011, 5, day)

    Timecop.freeze(date) do
      DailyCron.work
    end
  end
end