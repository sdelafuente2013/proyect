up:
	scripts/up.sh

down:
	docker-compose --project-name toluser_api down

tol_test_prepare:
	RAILS_ENV="test" bundle exec rails db:create

tolmex_test_prepare:
	RAILS_ENV="test" bundle exec rails mexico:db:create

latam_test_prepare:
	RAILS_ENV="test" bundle exec rails latam:db:create

tirantid_test_prepare:
	RAILS_ENV="test" bundle exec rails tirantid:db:create

test_prepare:
	rm -rf bin
	yes | bundle exec rake app:update:bin
	make tol_test_prepare tolmex_test_prepare latam_test_prepare tirantid_test_prepare
	RAILS_ENV="test" bundle exec rails db:prepare_for_tests

run_specs:
	bundle exec rspec --fail-fast

test:
	make test_prepare run_specs
