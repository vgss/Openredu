# -*- encoding : utf-8 -*-
namespace :populate do

    #Tasks Constants:
      USR_NMBR = 50
      TCH_NMBR = 50
      ENV_NMBR = 5

    #Tasks Description:
    #   default_admin: Insert a single superuser
    #   default_user: Insert USR_NMBR users
    #   default_teacher: Insert TCH_NMBR teachers
    #   default_environments: Insert ENV_NMBR environments


  desc "Insert test administrator"
  task :default_admin => :environment do
    User.reset_callbacks(:save)
    User.reset_callbacks(:create)
    theadmin = User.new(:login => 'administrator',
                        :email => 'redu@redu.com.br',
                        :password => 'reduadmin123',
                        :password_confirmation => 'reduadmin123',
                        :birthday => 20.years.ago,
                        :first_name => 'Admin',
                        :last_name => 'Redu',
                        :activated_at => Time.now,
                        :last_login_at => Time.now,
                        :role => Role[:admin])
    theadmin.role = Role[:admin] # O default é member
    theadmin.save
    theadmin.create_settings!
  end

  desc "Insert #{USR_NMBR} test users"
  task :default_user => :environment do

    user_fake_logins = ["arthurfontes", "vicentecarreira", "fontoura_vin_ciusda", "sroriz-la", "henriquearag-arthur-o", "gabrielaregueira", "silveira_gorda", "marceladantas", "mariacaseira", "lorenacarvalho", "m_rciafontes", "gabrieldomingues", "giuliada_luz", "claricemartins", "silva_warleyda", "valentinalouzada", "antoniasim_o", "eloah_lvares", "felipelopes_luiz", "alves.jo.o.gabrielgon", "malureis", "pedroso-cau", "lucasantena", "enzoveloso", "malujesus", "eduardada_veiga", "melissaesteves", "isabellylouzada", "bentoveles", "mathiasbarros", "go.gabrielar", "theos", "biancasales", "alessandraroriz", "maria_helenabrum", "m-rciamatoso", "m-rciacaldeira", "luizbarreira-davi", "claricepereira", "rciomarcondes.m", "igorda.costa", "sarahrios", "penha_carlosda", "ruangarcez", "louisepalhares", "jo-o-miguelcerqueira", "vicentemangueira", "o-karlagalv", "carolinaarriaga", "nicolesanches"]    
    user_fake_emails = ["arthur@example.org", "vicente@example.net", "vin.cius@example.net", "la_s@example.net", "henrique.arthur@example.com", "gabriela@example.com", "gor@example.org", "marcela@example.com", "maria@example.org", "lorena@example.org", "m.rcia@example.com", "gabriel@example.com", "giulia@example.com", "clarice@example.org", "warley@example.com", "valentina@example.com", "antonia@example.com", "eloah@example.com", "luiz_felipe@example.org", "jo.o.gabriel@example.net", "malu@example.com", "cau@example.org", "lucas@example.net", "enzo@example.com", "malu@example.org", "eduarda@example.net", "melissa@example.org", "isabelly@example.com", "bento@example.com", "mathias@example.net", "gabriela@example.org", "theo@example.com", "bianca@example.org", "alessandra@example.org", "helena.maria@example.net", "rcia_m@example.org", "m.rcia@example.org", "luiz.davi@example.net", "clarice@example.com", "rcio_m@example.net", "igor@example.com", "sarah@example.com", "carlos@example.net", "ruan@example.org", "louise@example.net", "jo.o.miguel@example.com", "vicente@example.net", "karla@example.com", "carolina@example.com", "nicole@example.net"]    
    user_fake_passwords = ["ZrCgXaMb2sFkLaNd", "6y8nGpJmB0LzAb08", "7644Ts72JdGr5z", "I9I7VeAy360vLtQm", "M0UyVnUxDiC1YnX", "SrR85k5lGeB", "Ka1pWzSxJuAy", "Yr70CpF42nYjD", "Wl8uJtVwWsGp3", "F8TnVy2bJbWkA", "42Js2qKz50N", "Ta3jHvMmQe5", "GwJg98Kg1fHb", "F0LaC0LgXj7gL65u", "DtYp07NuT3S", "469jExRe20G", "6iB6Bt2fW1Tq", "IrHdH0MuPzDbHwXi", "JxQfRgXnO4B6T8", "5yPz3bF56yZgX8Pr", "5y7352SsRuO", "RtSf52Vb56A", "Zg00YuIhCe3", "I5NeEf1yM3Rs", "745kEoX1JxJbO8Z", "Zy4mCeXlUqZ", "Z1Cc95Rr1u2mC", "Ml7rSvOoYfGuOtM", "L5My854u6tM", "0353KxMs9dLu", "AuL8WoEyOfGl", "5qRuEjGnGjW79", "NcMgDkYl5m94Ku49", "31WrV9Tu1lJ4U47", "7kSrTmBeEh5oYjRb", "D35pM2YlF1406j3b", "GzTiOvW1AyQdI26f", "3jEqPb9c4p1m", "NqWsPtOtU5FbHq", "WuI73yTjBw5c", "DfKt4bDxCsSvOpS2", "PkY2E956A3K2X", "Qc7sXlSh9zP", "XhIpJ7HkUmEqT", "0sGd6m6cCh470eS2", "5p3uDrAtTdSbOcGs", "XzFx3976E0B42e1", "Bn8iXc8q1h1nMx", "Z1Fk4852WsVxCaR3", "Te20GcKlM3N7RlXb"]
    user_fake_ages = [39, 43, 33, 23, 62, 29, 46, 24, 63, 29, 39, 30, 58, 36, 19, 26, 53, 23, 36, 63, 32, 40, 58, 34, 18, 32, 35, 54, 41, 34, 25, 54, 38, 50, 55, 42, 65, 17, 55, 59, 56, 46, 52, 36, 28, 32, 28, 25, 17, 58]
    user_fake_first_names = ["Arthur", "Vicente", "Vinícius", "Laís", "Arthur Henrique", "Gabriela", "Ígor", "Marcela", "Maria", "Lorena", "Mércia", "Gabriel", "Giulia", "Clarice", "Warley", "Valentina", "Antonia", "Eloah", "Luiz Felipe", "João Gabriel", "Malu", "Cauã", "Lucas", "Enzo", "Malu", "Eduarda", "Melissa", "Isabelly", "Bento", "Mathias", "Gabriela", "Theo", "Bianca", "Alessandra", "Maria Helena", "Márcia", "Márcia", "Davi Luiz", "Clarice", "Márcio", "Igor", "Sarah", "Carlos", "Ruan", "Louise", "João Miguel", "Vicente", "Karla", "Carolina", "Nicole"]
    user_fake_last_names = ["Fontes", "Carreira", "da Fontoura", "Roriz", "Aragão", "Regueira", "da Silveira", "Dantas", "Caseira", "Carvalho", "Fontes", "Domingues", "da Luz", "Martins", "da Silva", "Louzada", "Simão", "Álvares", "Lopes", "Gonçalves", "Reis", "Pedroso", "Antena", "Veloso", "Jesus", "da Veiga", "Esteves", "Louzada", "Veles", "Barros", "Rêgo", "Sá", "Sales", "Roriz", "Brum", "Matoso", "Caldeira", "Barreira", "Pereira", "Marcondes", "da Costa", "Rios", "da Penha", "Garcez", "Palhares", "Cerqueira", "Mangueira", "Galvão", "Arriaga", "Sanches"]

    usr_counter = 0

    USR_NMBR.times do
        User.reset_callbacks(:save)
        User.reset_callbacks(:create)
        theuser = User.new( :login => user_fake_logins[usr_counter],
                            :email => user_fake_emails[usr_counter],
                            :password => 'usuarioteste123',               #user_fake_passwords[usr_counter], 
                            :password_confirmation => 'usuarioteste123',  #user_fake_passwords[usr_counter],
                            :birthday => user_fake_ages[usr_counter].years.ago,
                            :first_name => user_fake_first_names[usr_counter],
                            :activated_at => Time.now,
                            :last_login_at => Time.now,
                            :last_name => user_fake_last_names[usr_counter],
                            :role => Role[:member])
        theuser.save
        theuser.create_settings!

        usr_counter += 1
    end
  end

  desc "Insert #{TCH_NMBR} test teachers"
  task :default_teacher => :environment do

    teacher_fake_logins = ["danielnovaes", "penha.cioda.fabr", "gustavocampos", "o.rebecade.assun", "natanielmodesto", "claricepalhares", "auroracarneiro", "raulleiria", "emanuelfarias", "enzoparreira", "erickpaes", "henriquevimaranes_pedro", "rafaelbarreira", "anapalhares", "emillyroriz", "luanamonteiro", "vit_o_rianegr", "louisebou.as", "carlos-mota-eduardoda", "giovannamonteira", "agathapalhares", "vit.riaaguiar", "f-biocarvalheira", "gabrielbatista-enzo", "davicrespo", "lauragarcez.maria", "carlosribeiro", "miguelrocha_enzo", "claramonteiro.maria", "o-miguelconcei-arthur", "jo_odos_reis", "o_pedro_lucasconcei", "alexandreveles", "ctorespinhosa-v", "la-scaldas", "of_liaespinheira", "s_ciade_al", "brunasantana", "isabelcorte", "fernandacardoso", "sarahbarata", "arthur-gabrielpalmeira", "lorenataveira", "rciafontinhas-m", "m_cunha_rciada", "marciapassarinho", "joanapaes", "al.ciada.mata", "rafaelagarc_s", "henriquejaques-arthur"]
    teacher_fake_emails = ["daniel@example.net", "fabr_cio@example.net", "gustavo@example.com", "rebeca@example.org", "nataniel@example.net", "clarice@example.net", "aurora@example.net", "raul@example.com", "emanuel@example.net", "enzo@example.org", "erick@example.org", "henrique_pedro@example.net", "rafael@example.com", "ana@example.net", "emilly@example.com", "luana@example.org", "ria.vit@example.org", "louise@example.com", "eduardo_carlos@example.com", "giovanna@example.org", "agatha@example.com", "ria_vit@example.com", "f_bio@example.net", "enzo_gabriel@example.net", "davi@example.org", "laura.maria@example.org", "carlos@example.net", "miguel.enzo@example.net", "clara.maria@example.net", "miguel.arthur@example.net", "o.jo@example.org", "lucas_pedro@example.org", "alexandre@example.net", "ctor.v@example.com", "la_s@example.com", "lia_of@example.net", "cia_al@example.com", "bruna@example.org", "isabel@example.org", "fernanda@example.org", "sarah@example.org", "arthur_gabriel@example.net", "lorena@example.org", "m.rcia@example.com", "rcia.m@example.org", "marcia@example.com", "joana@example.com", "cia_al@example.org", "rafaela@example.net", "arthur_henrique@example.org"]
    teacher_fake_passwords = ["RrRzAy8xZfG", "9xNtKaP62mXp", "X31aXaR3GbZmG2N", "S0UhArO9VkI", "6uQlC494UsW9", "4gToKuW6A3S93m", "6vP57o0e3dWq4gL", "39L900SqHqWmE2", "2aM48m1j0yUdLp", "2zApE9KpSj7f", "XlI876Ar5zY", "8zUrMnNnYnVb9l", "Y2JeY8X3Q2E4Jd87", "VqP9AiB2KoTb", "312nR0FhJzXe3", "0u9c1h1o2rByD", "M7C2AdSlQmJ3", "27U8Et94UmFw", "9ePbZ5R7QvBsQ", "6gChZi74MwB1T", "1jYx4dPsAhF0", "De1g9d29MxR", "02BbAhKp0hSx", "Zw8m41UjBi3uLpJ", "7gQjTvOnEg6", "CeDcAmK90y7", "NfYh86AiHsS", "57AlP8Ol16EgR3L", "2r7oB7B3BiO8MbJ", "X7JkOs748o6rS", "T3RfOxXp2v4", "K1Wx4iIrJbEyGd", "KoCcUcYnC53j40Xy", "7pBoA1LtClEw4oB", "3yVf7cW4EjVu", "F06wWtMiIgT", "W60n51K3J59w0vTy", "I38e73KrVt1iG", "O851I58f7iRg78", "RnT6MkWdZ0LzU4Ry", "YsX20a9dIrRl4", "A52xUuJpHr2w5hU", "SzCmVzYjKeZ4", "MjU0PmBeAlLf7", "XgQo3rNsEuG1Vm", "70Hi8tU01u78", "ZhTd9cV4Pg78I", "TbUtO3TaFtT", "F3Rm3qC0SaB1V", "BxE5U8SsR7ImN6Fu"]
    teacher_fake_ages = [36, 38, 52, 32, 50, 51, 22, 22, 29, 40, 39, 27, 62, 23, 44, 45, 48, 65, 29, 26, 27, 55, 40, 64, 30, 47, 62, 37, 28, 39, 22, 45, 53, 23, 37, 29, 39, 52, 26, 58, 46, 42, 34, 64, 42, 43, 43, 26, 57, 41]
    teacher_fake_first_names = ["Daniel", "Fabrício", "Gustavo", "Rebeca", "Nataniel", "Clarice", "Aurora", "Raul", "Emanuel", "Enzo", "Erick", "Pedro Henrique", "Rafael", "Ana", "Emilly", "Luana", "Vitória", "Louise", "Carlos Eduardo", "Giovanna", "Agatha", "Vitória", "Fábio", "Enzo Gabriel", "Davi", "Maria Laura", "Carlos", "Enzo Miguel", "Maria Clara", "Arthur Miguel", "João", "Pedro Lucas", "Alexandre", "Víctor", "Laís", "Ofélia", "Alícia", "Bruna", "Isabel", "Fernanda", "Sarah", "Arthur Gabriel", "Lorena", "Márcia", "Márcia", "Marcia", "Joana", "Alícia", "Rafaela", "Arthur Henrique"]
    teacher_fake_last_names = ["Novaes", "da Penha", "Campos", "de Assunção", "Modesto", "Palhares", "Carneiro", "Leiria", "Farias", "Parreira", "Paes", "Vimaranes", "Barreira", "Palhares", "Roriz", "Monteiro", "Negrão", "Bouças", "da Mota", "Monteira", "Palhares", "Aguiar", "Carvalheira", "Batista", "Crespo", "Garcez", "Ribeiro", "Rocha", "Monteiro", "Conceição", "dos Reis", "Conceição", "Veles", "Espinhosa", "Caldas", "Espinheira", "de Sá", "Santana", "Corte", "Cardoso", "Barata", "Palmeira", "Taveira", "Fontinhas", "da Cunha", "Passarinho", "Paes", "da Mata", "Garcês", "Jaques"]

    usr_counter = 0

    USR_NMBR.times do
        User.reset_callbacks(:save)
        User.reset_callbacks(:create)
        teacher = User.new( :login => teacher_fake_logins[usr_counter],
                            :email => teacher_fake_emails[usr_counter],
                            :password => 'professorteste123',               #teacher_fake_passwords[usr_counter], 
                            :password_confirmation => 'professorteste123',  #teacher_fake_passwords[usr_counter],
                            :birthday => teacher_fake_ages[usr_counter].years.ago,
                            :first_name => teacher_fake_first_names[usr_counter],
                            :activated_at => Time.now,
                            :last_login_at => Time.now,
                            :last_name => teacher_fake_last_names[usr_counter],
                            :role => Role[:teacher])
        teacher.save
        teacher.create_settings!

        usr_counter += 1
    end
  end


  ###NOT WORKING
  desc "Insert #{ENV_NMBR} test environments"
  task :default_environments => :environment do

    env_fake_names = ["Centro de Informática", "Centro de Ciências Sociais Aplicadas", "Centro de Filosofia e Ciências Humanas", "Centro de Tecnologia e Geociências", "Centro de Artes e Comunicação"]
    env_fake_paths = ["cin-ufpe", "ccsa-ufpe", "cfch-ufpe", "ctg-ufpe", "cac-ufpe"]
    env_fake_initials = ["CIN", "CCSA", "CFCH", "CTG", "CAC"]

    env_counter = 0

    #administrator is always the environment creator
    env_owner = User.find_by_login('administrator')

    ENV_NMBR.times do
        Environment.reset_callbacks(:save)
        Environment.reset_callbacks(:create)

        env = Environment.new(  :user_id => env_owner.id,  
                                :name => env_fake_names[env_counter],
                                :path => env_fake_paths[env_counter],               #teacher_fake_passwords[usr_counter], 
                                :initials => env_fake_initials[env_counter])  #teacher_fake_passwords[usr_counter],
        env.save
        #env.create_environment_association!

        puts env.id

        #NOT WORKING
        assoc = UserEnvironmentAssociation.new( :environment_id => env.id,
                                                :role => 'environment_admin',
                                                :user_id => env_owner.id )
        assoc.save
        
        
        env_counter += 1
    end
  end

  #cadastra usuarios nos apps do walledgarden
  desc "Generate Oauth Keys for all users and applications"
  task :generatekeys => :environment do
    User.all.each do |u|
      ClientApplication.where(:walledgarden => true).each do |app|
        Oauth2Token.create(client_application: app, user: u)
      end
    end
  end


 

  desc "Run all bootstrapping tasks"
  task :all => [:default_user, 
                :default_teacher, 
                :default_admin,
                :generatekeys]
end

