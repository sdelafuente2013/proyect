# TolUserAPI

## System dependencies for development

  - Ruby version 2.5.5
  - MySQL server
  - MongoDB
  - Redis

## Installation

If errors happen while running installation, check the *Troubleshooting* section at the end of this document.

As any Ruby application, you have to run:

```sh
bundle install
```


## Configuration for development

For first time setup you have to do this:

- Run this command to generate the Rails bin files:

```sh
bundle exec rake app:update:bin
```

- Define your development/test DB configuration: copy `config/application_sample.yml` to `config\application.yml` and edit according to your local DB setup.

- This command runs all the necesary tasks for preparing you database for tests:

```sh
bundle exec rake db:prepare_for_tests
```
- Run this commands for prepare your database for Brazil:

```sh
RAILS_ENV="test" bundle exec rake brazil:db:drop brazil:db:create brazil:db:schema:load brazil:db:migrate
```

- Run this commands for prepare your database for Latam:

```sh
RAILS_ENV="test" bundle exec rake latam:db:drop latam:db:create latam:db:schema:load latam:db:migrate
```

- Run this commands for prepare your database for Mexico:

```sh
RAILS_ENV="test" bundle exec rake mexico:db:drop mexico:db:create mexico:db:schema:load mexico:db:migrate
```

- Mongo Indexes:

For generate all mongo index run:

`rake db:mongoid:create_indexes`

For destroy all mongo index run:

`rake db:mongoid:remove_indexes`

For run specific mongo index choose model:

`rake Esp::UserSessionToken.remove_indexes`

# Migrations Mysql

  Creando y ejecutando migrations en entorno de test y dev:
  - Spain
```
    rails g active_record:migration create_autor_bibliografia

    RAILS_ENV="test" bundle exec rake db:migrate

    bundle exec rake db:migrate
```

  - Mexico
```
    rails g mexico_migration create_editorial

    RAILS_ENV="test" bundle exec rake mexico:db:migrate

    bundle exec rake mexico:db:migrate
```

  - Latam
```
    rails g latam_migration NombreDeLaClase

    RAILS_ENV="test" bundle exec rake latam:db:migrate

    bundle exec rake latam:db:migrate
```

  - tirantid
```
    bundle exec rails g tirantid_migration CrearEditorial

    bundle exec rake tirantid:db:migrate

    RAILS_ENV="test" bundle exec rake tirantid:db:migrate
```

Al crear nuevas migraciones y ejecutarlas en el entorno de test hay que subir el schema para mantenerlo actualizado

Al lanzar las migraciones en el entorno de desarrollo o cualquier otro, descartamos el schema nuevo que se genera, ya que contiene tablas de otros proyectos
## Run in development

## Sidekiq

- You have to run your redis server.
- Fill correctly `config/initializers/sidekiq.rb`
- Set your Redis URL in environment with: `ENV['REDIS_URL']=<your_redis_url>`
- And finally run sidekiq with: `bundle exec sidekiq -C config/sidekiq.yml`


## In development you can view the emails sent accessing to the following path:

`/letter_opener`

Link in those emails that points to tolweb generates the host depending on configuration.
There are a settings file in `config/settings/development_sample.yml` that defines the host
for each tirant channel. Copy it to `config/settings/development.yml` and define your tolweb port.
You can run tolweb in an specific port with:

```rails s -p 3005````

### Application

To start the application in your computer, you can select one of the following commands that suits your needs, and run it from your api folder.

Start for development on port 3001
`RAILS_ENV=development bundle exec rake start`

Start for test using default setup
`bundle exec rake start`

Or set your own parameters if you need it
`RAILS_ENV=<environment> bundle exec rake start port=<port>`

## For production, run this commands in your MySQL shell:

```sh
alter table usuario modify column iscolectivo TinyInt(1) not null default 0;
alter table usuario modify column actualizaciones TinyInt(1) not null default 0;
alter table usuario modify column isdemo TinyInt(1) not null default 0;
alter table per_subscription modify column news TinyInt(1) not null default 1;
alter table per_subscription modify column countrynews TinyInt(1) not null default 1;
alter table contactos_comerciales modify column iscolectivo TinyInt(1) not null default 0;
alter table contactos_comerciales modify column publicidad TinyInt(1) not null default 0;
alter table docindice_settings modify column voz TinyInt(1) not null default 0;
alter table al_convenio_solr modify column enviado TinyInt(1) not null;
alter table al_convenio_solr modify column confirmado TinyInt(1) not null;
alter table al_subvencion_solr modify column enviado TinyInt(1) not null;
alter table despsorigen modify column asignable TinyInt(1);
alter table docindice modify column hoja TinyInt(1) not null;
alter table docindice modify column en_vacatio TinyInt(1);
alter table docindice_search modify column hoja TinyInt(1);
alter table docs_analizados  modify column versiones TinyInt(1) not null default 0;
alter table novedad  modify column athome TinyInt(1);
alter table novedad  modify column destacado TinyInt(1);
alter table novedad  modify column to_latam TinyInt(1);
alter table novedad_historico  modify column athome TinyInt(1);
alter table novedad_historico  modify column destacado TinyInt(1);
alter table  per_directory_search modify column is_latam TinyInt(1);
alter table producto  modify column activo TinyInt(1) not null default 0;
alter table servicio modify column athome TinyInt(1)  not null default 0;
alter table servicio modify column hide TinyInt(1) default 0;
alter table terminos modify column hassinonimosrt TinyInt(1);
alter table terminos modify column hasresumen TinyInt(1);
alter table terminos modify column voz TinyInt(1);
alter table terminos modify column userok TinyInt(1);
alter table tolusuarios_admin_user modify column account_expired TinyInt(1) not null;
alter table tolusuarios_admin_user modify column account_locked TinyInt(1) not null;
alter table tolusuarios_admin_user modify column enabled TinyInt(1) not null;
alter table tolusuarios_admin_user modify column password_expired TinyInt(1) not null;

```

> Note: If you have problems in test or development with any of this fields, you can run this commands in your MySQL shell for Fix it.

## Updating the right urls and paths of LATAM and MEX subsystems

A rake task is provided for updating `url` and `path` fields of LATAM and MEX subsystems. When needed, run the `update_subsystems` task. Be sure to always set the proper environment (test, development, production) with RAILS_ENV before running the task, or else it will fail. For instance:

```
$ RAILS_ENV=test bundle exec rake update_subsystems
```

## Initialization of DB tables

Several `seeder:*` rake tasks allow easy initialization of some DB tables, when needed. Always set RAILS_ENV variable before running these tasks.

- `tolgeos` table is needed for backoffice users management. Initialize standard values with:

```sh
$ RAILS_ENV=development bundle exec rake seeder:tolgeos
```

- `backoffice_users` passwords are stored as hashes. Initialize passwords for all backoffice users at once with:

```sh
$ RAILS_ENV=development bundle exec rake seeder:backoffice_user_passwords[your_password_here]
```

- `backoffice_users_tolgeos` stores references to available tolgeos for every backoffice user. Quickly add access to all tolgeos for all backoffice users with:

```sh
$ RAILS_ENV=development bundle exec rake seeder:backoffice_user_tolgeos
```

## Troubleshooting

#### >> 'rake app:update:bin' fails because can't find libssl library

- Problem detected on Mac Os High Sierra 10.13.4. Suspected cause is OpenSSL has been replaced by LibreSSL:

```sh
$ openssl version
LibreSSL 2.2.7
```

- Example of error output:

```sh
$ bundle exec rake app:update:bin
rake aborted!
LoadError: dlopen(/Users/etordera/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/mysql2-0.4.10/lib/mysql2/mysql2.bundle, 9): Library not loaded: libssl.1.0.0.dylib
  Referenced from: /Users/etordera/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/mysql2-0.4.10/lib/mysql2/mysql2.bundle
  Reason: image not found - /Users/etordera/.rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/mysql2-0.4.10/lib/mysql2/mysql2.bundle
/Users/etordera/workspaces/ruby/toluserapi/api/config/application.rb:12:in `<top (required)>'
/Users/etordera/workspaces/ruby/toluserapi/api/Rakefile:4:in `require_relative'
/Users/etordera/workspaces/ruby/toluserapi/api/Rakefile:4:in `<top (required)>'
(See full trace by running task with --trace)
```

- Solution: Install OpenSSL and create needed symlinks

Download latest OpenSSL sources (1.1.0 at the time of writing): <https://www.openssl.org/source/>

Compile and install:

```sh
$ ./configure
$ make
$ make test
$ sudo make install
```

Create symlinks that provide the filenames needed by rake:

```sh
$ sudo ln -s /usr/local/lib/libcrypto.1.1.dylib /usr/local/lib/libcrypto.1.0.0.dylib
$ sudo ln -s /usr/local/lib/libssl.1.1.dylib /usr/local/lib/libssl.1.0.0.dylib
```

#### >> mysql database connection fails with selects including 'GROUP BY'

- Example of error output:

```sh
 Mysql2::Error:
   Expression #4 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'tolpro_test.usuario_stats.id' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
```

- Solution: remove 'only_full_group_by' from @@GLOBAL.sql_mode configuration:

Note all current options in @@GLOBAL.sql_mode

```sh
$ mysql -u root -p
mysql> select @@GLOBAL.sql_mode;
+------------------------------------------------------------------------------------------------------------------------+
| @@GLOBAL.sql_mode                                                                                                      |
+------------------------------------------------------------------------------------------------------------------------+
| ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION |
+------------------------------------------------------------------------------------------------------------------------+
```

Create custom MySQL configuration in `/usr/local/mysql/etc/my.cnf`. Define @@GLOBAL.sql_mode with all current options except ONLY_FULL_GROUP_BY:

```sh
[mysqld]
sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
```

Restart mysql server (GUI available in system preferences panel)

You can also solve this issue directly with.

```
$ mysql -u root -p
mysql> SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
```

With this solution you'll have to execute this command every time you restart Myql.

## How to deploy in gaspat.tirant.net

1. Connect via ssh to `gaspar.tirant.net` with the user `tol`, you can use:

`ssh tol@gaspar.tirant.net`

It ask for a password, you can find the password by asking to any mate ;)

2. Go to TolUserApi folder, with:

`cd /home/tol/tol_user/toluserapi/api`

3. Kill the puma and sidekiq Api process. You need their PID process with:

`ps -aux | grep api | grep tol | grep 3001` for puma api process
`ps -aux | grep api | grep tol | grep sidekiq` for sidekiq api process

Once you have the PID, you can kill the process with:

`kill -9 <PID_PUMA_API>`
`kill -9 <PID_SIDEKIQ_API>`

4. Now you have to save all the config files in the git stash, with:

`git add -A`
`git stash`

5. After that you have to pull the new changes, with:

`git pull`

6. Is time for bring back the config file, with:

`git stash pop`

Warning: Usually it can have conflict with the `Gemfile.lock`, just delete the file with `rm Gemfile.lock`

7. Now we have to update the libraries, with:

`rvm use ruby-2.4.1`
`rvm gemset use apitol`
`bundle install`
`bundle update`

8. Just export the environment variables:

`XT_API_BASE_FOROS="http://foros.tirant.net"`
`XT_API_BASE_FOROS_PASS="medaigual"`
`export RAILS_ENV=development`

9. Run the sidekiq with:

` `

10. Run the server with:

`nohup bundle exec rails s -p 3001 --binding=0.0.0.0 > log/apitol.log &`

11. Remember to check if everithing is running:

For check redis: `ps -aux | grep api | grep tol | grep sidekiq`
For check api:
`ps -aux | grep api | grep tol | grep 3001`
`tail -f log/apitol.log`
