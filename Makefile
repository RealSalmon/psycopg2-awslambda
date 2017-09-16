container := temp-psycopg2-lambda-$(shell /bin/bash -c "echo $$RANDOM")
image := local/psycopg2-lambda
file := python-3.6.2_psycopg2-2.7.3.1_postgresql-9.6.5_amazonlinux.tar.gz

default:
	docker build -t $(image) .
	docker run --name $(container) $(image) /bin/true
	docker cp $(container):/usr/local/src/$(file) ./
	docker cp $(container):/usr/local/src/psycopg2-2.7.3.1/build/lib.linux-x86_64-3.6/psycopg2 ./tests/psycopg2
	docker rm $(container)

shell:
	docker run -it $(image) bash

clean:
	docker rmi $(image) realsalmon/amazonlinux-python
	rm -f $(file)
	rm -rf ./tests/psycopg2
	cd tests && docker-compose down --rmi all

.PHONY: tests
tests: default
	cd tests && \
	(docker-compose up --abort-on-container-exit || echo "!!!TESTS FAILED!!!") && \
	docker-compose down
