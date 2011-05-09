class NotifierController < ApplicationController

  def invite
    @people = Person.make_groups.sample
  end

  def remind
    @person = Person.all.sample
  end

end