require 'spec_helper'

describe Notifier do
  describe ".send_reminders" do
    it "should send 2 emails to 8 people, in groups of 4" do
      YAML.stub(:load_file).with("#{Rails.root}/config/people.yml") { %w(
                              1@example.com
                              2@example.com
                              3@example.com
                              4@example.com
                              5@example.com
                              6@example.com
                              7@example.com
                              8@example.com
                            ) }
      Notifier.send_reminders

      ActionMailer::Base.deliveries.length.should == 2
      ActionMailer::Base.deliveries[0].to.length.should == 4
      ActionMailer::Base.deliveries[1].to.length.should == 4
    end
  end
end