# QuickTravel

[![Gem Version](https://badge.fury.io/rb/quicktravel_client.svg)](http://badge.fury.io/rb/quicktravel_client)
[![Build Status](https://github.com/sealink/quicktravel_client/workflows/Build%20and%20Test/badge.svg?branch=master)](https://github.com/sealink/quicktravel_client/actions)
[![Coverage Status](https://coveralls.io/repos/sealink/quicktravel_client/badge.svg)](https://coveralls.io/r/sealink/quicktravel_client)
[![Code Climate](https://codeclimate.com/github/sealink/quicktravel_client/badges/gpa.svg)](https://codeclimate.com/github/sealink/quicktravel_client)

# DESCRIPTION

Gives models that are integrated with the QuickTravel API

# INSTALLATION

Add to your Gemfile:

```
gem 'quicktravel_client'
```

# REGENERATE CASSETTES

In QuickTravel:
```
mysql quicktravel_test < ../quicktravel_test/bootstrap.sql
TIMECOP=1 WEBMOCK=0 QUICKTRAVEL_CONFIG_DIR=spec/support/config RAILS_ENV=test bundle exec rails s -p8080
```

In Payment Service: (if needing to generate checkout cassettes):
```
bundle exec puma -Ilib -p7000
```

In QuickTravel Client:
```
rm spec/support/cassettes/ -rf
QT_KEYS=a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2,1b0a9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c3b2a1f0e9d8c7b6a5f4e3d2c1b0a bundle exec rspec
```

# RELEASE

To publish a new version of this gem the following steps must be taken.

* Update the version in the following files
  ```
    CHANGELOG.md
    lib/quick_travel/version.rb
  ````
* Create a tag using the format v0.1.0
* Follow build progress in GitHub actions
