# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Environment do
  subject { FactoryGirl.create(:environment) }

  it { should have_many(:courses).dependent(:destroy) }
  it { should have_many(:user_environment_associations).dependent(:destroy) }
  it { should have_many(:users).through(:user_environment_associations)}
  it { should have_many(:administrators).through(:user_environment_associations)}
  it { should have_many(:users).through(:user_environment_associations)}
  it { should have_many(:users).through(:user_environment_associations)}
  it { should have_many(:plans) }
  it { should belong_to(:owner)}
  it { should accept_nested_attributes_for :courses }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:path) }
  it { should validate_presence_of(:initials) }

  xit { should validate_uniqueness_of(:name) }
  xit { should validate_uniqueness_of(:path) }
  it { should allow_value("teste-medio1").for(:path)}
  it { should ensure_length_of(:name).is_at_most 40 }
  it { should ensure_length_of(:initials).is_at_most(10)}
  it { should ensure_length_of(:description).is_at_most(400)}

  it { should_not allow_mass_assignment_of(:owner)}
  it { should_not allow_mass_assignment_of(:published)}

  context "validations" do
    it "ensure format for path: doesn't accept space" do
      subject.path = "teste medio"
      subject.should_not be_valid
      subject.errors[:path].should_not be_empty
    end

    it "ensure format for path: doesn't accept '?'" do
      subject.path = "teste-medio?"
      subject.should_not be_valid
      subject.errors[:path].should_not be_empty
    end

    it "doesnt accept ." do
      subject.path = "www.redu.com.br"
      subject.should_not be_valid
      subject.errors[:path].should_not be_empty
    end
  end

  context "finders" do
    it "retrieves a Environment by its path" do
      Environment.find(subject.path).should == subject
    end

    it "retrieves all members" do
      users = 5.times.inject([]) { |res, i| res << FactoryGirl.create(:user) }
      FactoryGirl.create(:user_environment_association, :user => users[0],
              :environment => subject, :role => :environment_admin)
      FactoryGirl.create(:user_environment_association, :user => users[1],
              :environment => subject, :role => :environment_admin)
      FactoryGirl.create(:user_environment_association, :user => users[2],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[3],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[4],
              :environment => subject, :role => :member)
      subject.users.to_set.
        should == (users << subject.owner).to_set
    end

    it "retrieves all administrators" do
      users = 5.times.inject([]) { |res, i| res << FactoryGirl.create(:user) }
      FactoryGirl.create(:user_environment_association, :user => users[0],
              :environment => subject, :role => :environment_admin)
      FactoryGirl.create(:user_environment_association, :user => users[1],
              :environment => subject, :role => :environment_admin)
      FactoryGirl.create(:user_environment_association, :user => users[2],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[3],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[4],
              :environment => subject, :role => :member)
      subject.administrators.to_set.
        should == [users[0], users[1], subject.owner].to_set
    end

    it "retrieves all teachers" do
      users = 5.times.inject([]) { |res, i| res << FactoryGirl.create(:user) }
      FactoryGirl.create(:user_environment_association, :user => users[0],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[1],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[2],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[3],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[4],
              :environment => subject, :role => :member)
      subject.teachers.to_set.
        should == [users[0], users[1], users[2]].to_set
    end

    it "retrieves all tutors" do
      users = 5.times.inject([]) { |res, i| res << FactoryGirl.create(:user) }
      FactoryGirl.create(:user_environment_association, :user => users[0],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[1],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[2],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[3],
              :environment => subject, :role => :member)
      FactoryGirl.create(:user_environment_association, :user => users[4],
              :environment => subject, :role => :member)
      subject.tutors.to_set.
        should == [users[0], users[1]].to_set
    end

    it "retrieves all students (role member)" do
      users = 5.times.inject([]) { |res, i| res << FactoryGirl.create(:user) }
      FactoryGirl.create(:user_environment_association, :user => users[0],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[1],
              :environment => subject, :role => :tutor)
      FactoryGirl.create(:user_environment_association, :user => users[2],
              :environment => subject, :role => :teacher)
      FactoryGirl.create(:user_environment_association, :user => users[3],
              :environment => subject, :role => :member)
      FactoryGirl.create(:user_environment_association, :user => users[4],
              :environment => subject, :role => :member)
      subject.students.to_set.
        should == [users[3], users[4]].to_set
    end
  end

  it "changes a user role" do
    user = FactoryGirl.create(:user)
    subject.users << user
    subject.save

    expect {
      subject.change_role(user, Role[:environment_admin])
    }.to change {
      subject.user_environment_associations.last.role }.to(Role[:environment_admin])
  end

  it { should respond_to :plan }

  it "should return actual plan" do
    plan = FactoryGirl.create(:active_package_plan, :billable => subject, :current => false)
    plan2 = FactoryGirl.create(:active_package_plan, :billable => subject)

    subject.plan.should == plan2
  end

  context "callbacks" do
    it "creates an environment association" do
      subject.users.last.should == subject.owner
    end

    it "creates an approved course association with the first course" do
      user = FactoryGirl.create(:user)
      subject = FactoryGirl.create(:environment, :owner => user,
                        :courses => [FactoryGirl.create(:course, :owner => user)])
      subject.courses.first.owner.should == subject.owner
      subject.courses.first.users.should include(subject.owner)
      user.user_course_associations.last.state.should == 'approved'
    end
  end

  it "doesnt accept ." do
    subject.path = "www.redu.com.br"
    subject.should_not be_valid
    subject.errors[:path].should_not be_empty
  end

  it "by default is published" do
    subject.should be_published
  end

  context "when removes users" do
    let(:courses) do
      (1..3).collect { FactoryGirl.create(:course, :environment => subject) }
    end
    let(:users) { (1..3).collect { FactoryGirl.create(:user) } }

    before do
      courses.each do |c|
        (1..2).each { FactoryGirl.create(:space, :course => c) }
        c.spaces.reload
      end
      subject.courses.reload

      courses[0].join users[0]
      courses[0].join users[1]
      courses[0].join users[2]
      courses[0].users.reload

      courses[1].join users[1]
      courses[2].join users[2]
      courses[1].users.reload
      courses[2].users.reload

      subject.remove_users(users[0..1])
    end

    it "removes the users from the environment" do
      subject.users.should_not include(users[0..1])
    end

    # Tentativa de verificar a chamada ao unjoin
    it "removes the users from all courses" do
      courses[0].users.should_not include(users[0..1])
      courses[1].users.should_not include(users[0..1])
    end
  end

  context "with a course marked for destruction" do
    it "should destroy associated course" do
      subject.courses << \
        FactoryGirl.create(:course, :owner => subject.owner, :environment => subject,
                :destroy_soon => true)
      subject.courses.reload
      expect {
        subject.destroy
      }.to change(Course, :count).by(-1)
    end
  end
end
