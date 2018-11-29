# -*- encoding : utf-8 -*-
module Api
  class CoursesController < ApiController
    def index
      @environment = Environment.find(params[:environment_id])
      authorize! :read, @environment
      @courses = @environment.try(:courses) || []

      respond_with :api, @environment, @courses
    end

    def show
      @course = Course.find(params[:id])
      authorize! :read, @course

      respond_with :api, @course
    end

    def create
      authorize! :create, Environment
      @environment = Environment.find(params[:environment_id])
      @course = Course.new(params[:course]) do |c|
        c.environment = @environment
        c.owner = current_user
      end
      @course.save

      respond_with :api, @course
    end

    def update
      @course = Course.find(params[:id])
      authorize! :manage, @course
      @course.update_attributes(params[:course])

      respond_with @course
    end

    def destroy
      @course = Course.find(params[:id])
      authorize! :manage, @course
      @course.destroy

      respond_with :api, @course
    end
  end
end
