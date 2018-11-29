# -*- encoding : utf-8 -*-
class CourseObserver < ActiveRecord::Observer
  def after_create(course)
    Log.setup(course, :action => :create)
  end
end
