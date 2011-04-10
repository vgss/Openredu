class Subject < ActiveRecord::Base

  belongs_to :space
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :lectures, :order => "position", :dependent => :destroy
  has_many :enrollments, :dependent => :destroy
  has_many :members, :through => :enrollments, :source => :user
  has_many :graduated_members, :through => :enrollments, :source => :user,
    :include => :student_profiles,
    :conditions => ["student_profiles.graduaded = 1"]
  has_many :teachers, :through => :enrollments, :source => :user,
    :conditions => ["enrollments.role_id = ?", 5] # Teacher
  has_many :statuses, :as => :statusable, :dependent => :destroy
  has_many :logs, :as => :logeable, :dependent => :destroy, :class_name => 'Status'

  named_scope :recent, lambda {
    { :conditions => ['updated_at > ?', 1.week.ago] }
  }

  attr_protected :owner, :published, :finalized

  acts_as_taggable

  validates_presence_of :title
  validates_length_of :description, :within => 30..250
  validates_length_of :lectures, :minimum => 1, :on => :update

  def recent?
    self.updated_at > 1.week.ago
  end

  # Matricula o usuário com o role especificado. Retorna true ou false
  # dependendo do resultado
  def enroll(user, role = Role[:member])
    enrollment = self.enrollments.create(:user => user, :role_id => role.id)
    enrollment.valid?
  end

  # Desmatricula o usuário
  def unenroll(user)
    enrollment = user.get_association_with(self)
    enrollment.destroy
  end

  def publish!
   self.published = true
   self.save
  end

  def unpublish!
    Enrollment.destroy_all(["subject_id = ? and user_id <> ?",
                           self.id, self.user_id])
    self.published = false
    self.save
  end

  def change_lectures_order!(lectures_ordered)
    ids_ordered = []
    lectures_ordered.each do |lecture|
      ids_ordered << lecture.split("-")[0].to_i
    end

    ids_ordered.each_with_index do |id, i|
      lecture = Lecture.find(id)
      lecture.position = i + 1 # Para não ficar índice zero.
      lecture.save
    end
  end

  #TODO colocar esse metodo em status passando apenas o objeto
  # Não foi testado, pois haverá reformulação de subject
  def recent_activity(page = 1)
    self.statuses.not_response.
      paginate(:page => page, :order => 'created_at DESC',
               :per_page => AppConfig.items_per_page)
  end

  def convert_lectureables!
    documents = self.lectures.find(:all,
      :include => "lectureable",
      :conditions => {:lectureable_type => ["Document"]})
    documents.each { |d| d.lectureable.upload_to_scribd }

    seminars = self.lectures.find(:all,
      :include => "lectureable",
      :conditions => {:lectureable_type => ["Seminar"]})
    seminars.each do |s|
      s.lectureable.convert! if s.lectureable.need_transcoding?
    end
  end

  def create_enrollment_associations
    self.space.user_space_associations.each do |users_space|
      self.enrollments.create(:user => users_space.user, :subject => self,
                              :role => users_space.role)
    end
  end

end
