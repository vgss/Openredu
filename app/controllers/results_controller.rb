# -*- encoding : utf-8 -*-
class ResultsController < BaseController
  include ExercisesHelper
  before_filter :load_hierarchy, only: [:index, :edit]

  load_resource :exercise
  load_and_authorize_resource :result, except: :create

  def create
    authorize! :read, @exercise.lecture
    @result = @exercise.start_for(current_user)

    respond_to do |format|
      format.html do
        redirect_to exercise_question_path(@exercise, @exercise.questions.first(:conditions => { :position => 1 }))
      end
    end
  end

  def update
    @exercise.finalize_for(current_user)
    @subject = @exercise.lecture.subject
    @space = @subject.space

    respond_to do |format|
      format.html do
        redirect_to \
          space_subject_lecture_path(@space, @subject, @exercise.lecture)
      end
    end
  end

  def edit
    @first_question = @exercise.questions.
      first(conditions: { position: 1})
    @last_question = @first_question.last_item
    @result = @exercise.result_for(current_user, false)
    @choices_count = current_user.choices.by_exercise(@exercise).count
    @questions_count = @exercise.questions.count

    respond_to do |format|
      format.html { render 'results/admin/edit' }
    end
  end

  def index
    authorize! :manage, @lecture
    @results = Result.finalized.where(exercise_id: @exercise).
      includes(:user, :choices, exercise: :questions)

    respond_to do |format|
      format.html { render 'results/admin/index' }
    end
  end

  def download
    result = Result.find(params[:result_id])
    
    t = [["Enunciado", "Justificativa", "Resposta Correta", "Resposta do Aluno"]] + 
    result.choices.map do |item|
      [
        ActionView::Base.full_sanitizer.sanitize(item.question.statement), 
        ActionView::Base.full_sanitizer.sanitize(item.question.explanation), 
        ActionView::Base.full_sanitizer.sanitize(item.question.correct_alternative.text), 
        ActionView::Base.full_sanitizer.sanitize(item.alternative.text)
      ]
    end

    report = result.to_report

    pdf = Prawn::Document.new
    pdf.text "Aluno: #{result.user.display_name}"
    pdf.move_down 10
    pdf.text "Nota: #{report[:grade]}"
    pdf.move_down 10
    pdf.text "Acertos: #{report[:hits]}"
    pdf.move_down 10
    pdf.text "Erros: #{report[:misses]}"
    pdf.move_down 10
    pdf.text "Não respondeu: #{report[:blanks]}"
    pdf.move_down 10
    pdf.text "Duração do exame: #{detailed_period_of_time(report[:duration])}"
    pdf.move_down 20
    pdf.table t, position: :center
    pdf.move_down 30
    pdf.text "____________________________________________________", align: :center
    pdf.move_down 5
    pdf.text "Assinatura do professor ou Responsavel de sala", align: :center
    
    send_data pdf.render, 
    filename: "order_a",
    type: 'application/pdf',
    disposition: 'inline'

  end

  protected

  def load_hierarchy
    @exercise = Exercise.find(params[:exercise_id])
    @lecture = @exercise.lecture
    @subject = @lecture.subject
    @space = @subject.space
    @course = @space.course
    @environment = @course.environment
  end
end
