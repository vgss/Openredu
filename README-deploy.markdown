# Implantação do OpenRedu

Uma boa alternativa para a implantação do OpenRedu é uso do [Capistrano](https://github.com/capistrano/capistrano) com o plugin do [Rubber](https://github.com/rubber/rubber). Isto foi feito no OpenRedu que está sendo usado nos servidores do [CIn](http://www2.cin.ufpe.br/site/index.php) e está acessível através do endereço: http://redu-master.cin.ufpe.br/.

Nesta seção o intuito é justamente mostrar como a implantação foi feita nestes servidores utilizando tanto o Capistrano quanto o Rubber.

## Setup da Implantação

Como foi utilizado o [Rubber](https://github.com/rubber/rubber) para a instalação dos serviços necessários para o deployment, utilizamos um comando bastante útil para gerar todo o setup, o `vulcanize`. 

No caso do OpenRedu foi preciso instalar os seguinte serviços:

```bsh
rubber vulcanize complete_unicorn_nginx_mysql
rubber vulcanize solr_sunspot
rubber vulcanize memcached
rubber vulcanize mongodb
rubber vulcanize delayed_job
```

É possível verificar uma lista de templates que rubber possui nesse [link](https://github.com/rubber/rubber/tree/master/templates) para instalação de serviços.

Com esse setup foi instalado tudo que é preciso para o OpenRedu funcionar. Dependendo o local da instalação, algumas modificações deverão ser feitas como adição de pacotes ou bibliotecas de dependência. Destacando o `imagemagick` e o `libmagickwand-dev` que adicionado ao packages do `unicorn` no arquivo `configu/rubber/rubber-unicorn.yml`.

O [Quick Start](https://github.com/rubber/rubber/wiki/Quick-Start) do Rubber é uma excelente maneira de entender o que exatamente está ocorrendo.

## Implantação no CIn (servidores próprios)

O Rubber já vem com uma opção para instalação em servidores próprios. [Este guia](https://github.com/rubber/rubber/wiki/Providers#generic) mostra como fazer isso, assim como mostra para outros provedores.

Para servidores próprios é imprescindível ter acesso a SSH das máquinas sem que haja necessidade de login e senha.

### Possíveis problemas de SSH

Pode ser que haja alguns problemas em relação ao acesso do Capistrano/Rubber às máquinas, então é preciso:

- Adicionar as chaves SSH do desenvolvedor que fará o deploy aos servidores
- E caso ainda haja pedido de senha, cheque o arquivo `/etc/.ssh/sshd_config` e veja se contém as seguintes linhas:
    - PubkeyAuthentication yes
    - AuthorizedKeyFile    .ssh/authorized_keys
    - PasswordAuthentication no
- Reinicie o SSH `sudo service ssh restart` se for preciso

## Criando instâncias

O OpenRedu é composto por várias aplicações que utilizam vários serviços. As instâncias usadas no CIn são configuradas da seguinte maneira:

- redu-master: aplicação do OpenRedu 
- redu-db: mysql, mongodb
- redu-util: delayed_job, memcached, solr_sunspot e vis (aplicação de relatórios)

Para efetuar esse setup, foi usado o comando `cap rubber:create`. Mas esta configuração pode ser modificada, o  [Quick Start](https://github.com/rubber/rubber/wiki/Quick-Start) do Rubber explica muito bem como fazer essa alocações de `roles` para cada instância.

Ao efetuar o `rubber:create` para cada instância, uma série de perguntas serão feitas para que a configuração seja finalizada, dentre elas:

- nome para aplicação, esse nome será um alias para identifcar unicamente o servidor
- serviços que devem ser instalados
- ip externo da máquina
- ip interno da máquina

### Security Groups

Se a implantação for para várias máquinas é necessário a permissão que um máquina acesse a outra. Ou seja, você deverá criar security groups e adicioná-los as instâncias. Como exemplo, o redu-master acessa o redu-db e por isso a configuração do `instance-production.yml` para esta instância é a seguinte:

```bsh
---
- !ruby/object:Rubber::Configuration::InstanceItem
  name: web01
  domain: redu.cin.ufpe.br
  roles:
...
  instance_id: web01
  image_type:
  image_id:
  security_groups:
  - default
  - web
  - db
```

Lembrando que é preciso criar o security group `db`. Aacesso o arquivo `config/rubber/rubber.yml` e adicione:

```bsh
  web:
    description: "To open up port #{web_port}/#{web_ssl_port} for http server on web role"
    rules:
#   ...
      - protocol: tcp
        from_port: "#{web_mysql_port}"
        to_port: "#{web_mysql_port}"
        source_ips: [0.0.0.0/0]
  db:
    description: The db server security group to allow web servers to connect
    rules:
      - protocol: tcp
        from_port: "#{web_mysql_port}"
        to_port: "#{web_mysql_port}"
        source_ips: [0.0.0.0/0]
```

Depois das configuração definidas, lembre-se de rodar `cap rubber:setup_security_groups` para adicionar os security groups aos servidores.

## Bootstrap das instâncias

Se tudo foi bem configurado, será possível rodar `cap rubber:bootstrap` para finalização do setup nos servidores. Este comando instala e configura todos os servidores que serão usados.

## Deploy

O deploy para atualizar a instância para a última versão do código é bem simples, basta disparar `cap deploy` ou `cap deploy:cold` se for a primeira vez que estiver utilizando.

Caso estiver dando deploy pela primeira vez usando o `cap deploy:cold` é preciso adicionar dados seed. Se não o Redu não funcionará de maneira correta. 

É preciso entrar no servidor que estiver rodando a aplicação principal (redu-master) e até a pasta do projeto, que provavelmente estará em `/mnt/redu-production`, e executar:

```bash
bundle exec rake bootstrap:audiences
bundle exec rake bootstrap:partner
```