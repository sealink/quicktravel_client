QuickTravel
===========

[![Gem Version](https://badge.fury.io/rb/quicktravel_client.svg)](http://badge.fury.io/rb/quicktravel_client)
[![Build Status](https://travis-ci.org/sealink/quicktravel_client.svg?branch=master)](https://travis-ci.org/sealink/quicktravel_client)
[![Coverage Status](https://coveralls.io/repos/sealink/quicktravel_client/badge.svg)](https://coveralls.io/r/sealink/quicktravel_client)
[![Dependency Status](https://gemnasium.com/sealink/quicktravel_client.svg)](https://gemnasium.com/sealink/quicktravel_client)
[![Code Climate](https://codeclimate.com/github/sealink/quicktravel_client/badges/gpa.svg)](https://codeclimate.com/github/sealink/quicktravel_client)

# DESCRIPTION

Gives models that are integrated with the QuickTravel API

# INSTALLATION

Add to your Gemfile:
gem 'quicktravel_client'

# REGENERATE CASSETTES

In QuickTravel:
mysql quicktravel_test < ../quicktravel_test/bootstrap.sql
TIMECOP=1 WEBMOCK=0 QUICKTRAVEL_CONFIG_DIR=spec/support/config RAILS_ENV=test bundle exec rails s -p8080

In Payment Service: (if needing to generate checkout cassettes):
bundle exec puma -Ilib -p7000

In QuickTravel Client:
rm spec/support/cassettes/ -rf
QT_KEYS=a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2,a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2 bundle exec rspec
