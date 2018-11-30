# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'forgery'

# Script simples de população. Servirá como base para executar a importação posterior atraves do educacenso.
#1 -> Inserção de 1000 usuários. Os cem primeiros serão professores de cursos. O primeiro será o admin redu, e admin de todos os ambientes.
def create_users
    (1..1000).each do |i|
        email = Forgery('email').address
        user = User.new(:login => "user#{i}",
                            :first_name => Forgery('name').first_name,
                            :last_name => Forgery('name').last_name,
                            :password => "123456",
                            :password_confirmation => "123456",
                            :email => "#{email}",
                            :email_confirmation => "#{email}")

        user.role = Role[:member] # O default é member

        if i == 1
            user.role = Role[:admin]
        end

        user.save
        user.create_settings!
    end
end

#2 -> Inserção de 15 ambientes cujo criador é o user com id 1
def create_envs
    (1..15).each do |i|
        env = Environment.new(  :name=> Forgery('name').company_name,
                                :description=>"Descricao da Escola#{i}",
                                :path=>"env#{i}",
                                :avatar_file_name=>nil,
                                :avatar_content_type=>nil,
                                :avatar_file_size=>nil,
                                :avatar_updated_at=>nil,
                                :user_id=>1, #id do user que será environment admin (criador do ambiente)
                                :published=>true,
                                :initials=>"E#{i}",
                                :destroy_soon=>false,
                                :blocked=>false )
        env.save                             
    end
end

#3 -> Inserção de 100 cursos, distribuidos aleatoriamente entre os ambientes existentes, cujo criador é o user com id 1
def create_courses
    (1..100).each do |i|
        course = Course.new(:name=>"Curso#{i}",
                            :description=>"Descricao do Curso#{i}",
                            :path=>"curso#{i}",
                            :environment_id=>Environment.all.sample.id,
                            :workload=>nil,
                            :subscription_type=>1,
                            :user_id=>1,
                            :published=>true,
                            :destroy_soon=>false,
                            :blocked=>false)

        course.save                            
    end
end

#4 -> Inserção de 500 disciplinas, distribuidas aleatoriamente entre os cursos existentes, cujo criador é o user com id 1
def create_spaces
    (1..500).each do |i|
        Space.observers.disable :user_observer
        
        space = Space.new(  :name=>"Disciplina#{i}",
                            :description=>"Descricao da Disciplina #{i}",
                            :user_id=>1,
                            :avatar_file_name=>nil,
                            :avatar_content_type=>nil,
                            :avatar_file_size=>nil,
                            :avatar_updated_at=>nil,
                            :removed=>false,
                            :members_count=>0,
                            :published=>true,
                            :destroy_soon=>false,
                            :blocked=>false)
        space.course = Course.all.sample
        space.save                   
    end
end

def associate_user_to_courses
    i = 1

    User.all.each do |user|

        course = Course.all.sample

        if(i > 100)
            course.join(user)
        else
            course = Course.all[i-1]
            course.join(user, Role[:teacher])
        end

        i += 1
    end
end

####################################################################################################################

create_users()
create_envs()
create_courses()
create_spaces()
associate_user_to_courses()
