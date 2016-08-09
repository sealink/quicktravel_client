# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
This changelog adheres to [Keep a CHANGELOG](http://keepachangelog.com/).

## [2.3.0]
### Changed
 - Change cache expiries
- Adds support for passing dates to Resource#all_with_price

### Fixed
- Fixes issue with HTTParty ~> 0.14
- Updates HTTParty dependency to ~> 0.14

## [2.2.2]
### Changed
 - Deprecates Booking#calculate_price_quote
 - Fix when money is nil from QT

## [2.2.1] - 2016-04-18
### Fixed
 - Adds missing require for PriceQuote adapter

## [2.2.0] - 2016-04-18
### Added
 - PriceQuote adapter

## [2.1.0] - 2016-04-13
### Added
 - Resource categories
 - Products

## [2.0.0] - 2016-04-08
### Added
- This changelog
- Support for new ProductType API

### Changed
- Discount API renamed Price Change API
- Multiple internal refactorings and cleanups
- Changes Price Quotes API to support non segment based products

## [1.1.1] - 2015-06-22
### Fixed
- Fixed issue with Checkout API

## [1.1.0] - 2015-06-19
### Added
- Checkout API

## [1.0.2] - 2015-06-01
### Fixed
- Fixed issue with payment type code format

### Added
- Code attribute to passenger type

## [1.0.1] - 2015-03-04
### Fixed
- Fixed conflict between active_support and facets underscore method

## [1.0.0] - 2015-03-03
- Initial public release
