namespace :dev do
  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o Banco de Dados...") { %x(rails db:drop) }
      show_spinner("Criando Banco de Dados...") { %x(rails db:create) }
      show_spinner("Realizando Migrações...") { %x(rails db:migrate) }
      show_spinner("Cadastrando Administrador...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando Administradores Extras...") { %x(rails dev:add_extra_admins) }
      show_spinner("Cadastrando Usuário...") { %x(rails dev:add_default_user) }
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  #ADMINISTRADOR PADRÃO
  desc "Adiciona um Administrador Padrão do Sistema"
  task add_default_admin: :environment do
    Admin.create!(
      email: "admin@admin.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
    )
  end

  #ADMINISTRADORES
  desc "Adiciona outros Administradores ao Sistema"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
      )
    end
  end

  #USUÁRIO PADRÃO
  desc "Adiciona um Usuário Padrão do Sistema"
  task add_default_user: :environment do
    User.create!(
      email: "user@user.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
    )
  end

  #Metodos Privados
  private

  def show_spinner(msg_start, msg_end = "Concluído com sucesso!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
