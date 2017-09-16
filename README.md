# psycopg2-awslambda

[![CircleCI](https://circleci.com/gh/RealSalmon/psycopg2-awslambda.svg?style=svg)](https://circleci.com/gh/RealSalmon/psycopg2-awslambda)

## A Docker-based build of psycopg2 for AWS Lambda using Python 3.6

This project is based on the exellent 
[awslambda-psycopg2](https://github.com/jkehler/awslambda-psycopg2) work done
by [jkehler](https://github.com/jkehler), without which I never figured out how 
to build this properly.

It will produce a build of [psycopg2](http://initd.org/psycopg/) with a 
statically linked libpq library and  SSL support that is suitable for use with 
[AWS Lambda](https://aws.amazon.com/lambda/) (Python 3.6) for connecting to a
PostgreSQL database. The build  happens in an 
[Amazon Linux Docker container](https://hub.docker.com/_/amazonlinux/) so 
you can produce it locally with a minimum of hassle.

### Requirements
  - [Docker](https://www.docker.com/)
  - make

### Instructions
  - cd to this repository's root directory
  - run 'make'
  - grab a serving of your favorite beverage and wait for it to build
  
Sit tight, as this may take a while. After the build is complete, you should 
see a .tar.gz file in the repository's root directory (e.g. 
python-3.6.2_psycopg2-2.7.3.1_postgresql-9.6.5_amazonlinux.tar.gz). Inside this 
archive is the psycopg2 package that can be used with AWS Lambda.

### Clean up
  - cd to this repository's root directory
  - run 'make clean'
  
This will remove the (rather large) Docker image that was built for the purposes
of building psycopg2, the psycopg2 archive, and the 
realsalmon/amazonlinux-python Docker image. It will not remove the amazonlinux 
or postgresql Docker images, which you should delete manually if you do not 
wish to keep them. 

### Versions
  - Python 3.6.2
  - PostgreSQL 9.6.5
  - Psycopg 2.7.3.1
  - Amazon Linux 2017.03
