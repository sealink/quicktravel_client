# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
This changelog adheres to [Keep a CHANGELOG](http://keepachangelog.com/).

## Unreleased
### Changed

- [DC-1767] include long/lat changes to Stop

## [3.7.0]
### Added
- [DC-1437] Add relationship accesssor methods
- [TT-3337] Add booking.delete_reservations method
- [TT-3780] Add tests for Opal payments
- [TT-3780] Add tests for Opal payment using create / update workflow

### Fixed
- [TT-3304] Handle no response in booking update API

### Changed
- [TT-3333] URL encode data sent to booking reference lookup
- [TT-3783] Remove deprecated FixNum
- [TT-3812] Update cassettes

## [3.6.0]
###
- [ROT-114] Add drop off details

## [3.5.0]
###
- [TT-3147] Remove unused payment methods
- [TT-3278] Add full_response option to booking update

## [3.4.0]
###
- Properties now return their associated location and types

## [3.3.0]
### Added
- Price change reasons are now passed as an array

## [3.2.0]
### Changed
- Return status with QuickTravel::AdapterError

## [3.1.0]
### Added
- API to cancel a booking

## [3.0.0]
### Fixed
- Allow zero pricing for extra pick items

### Changed
- Use new reset password url

### Added
- Setting API

### Removed
- Removed geocode function on address

## [2.9.0]
### Changed
- Use new API login

### Removed
- Remove unused constants and default referral code

## [2.8.0]
### Changed
- @booking.accommodation_reserve now expects to be passed the adjusted last_travel_date

## [2.7.0]
### Added
- can_choose_stops? to check if a route has more than two stops

## [2.6.0]
### Removed
- Stop passing last_travel_date

## [2.5.0]
### Added
- Add call to get client token

## [2.4.1]
### Changed
- Handle nil values for empty lists

## [2.4.0]
### Changed
- Improve error handling when non JSON response
- Update test cassettes due to API changes
- Update test data due to new bootstrap.sql

## [2.3.1]
### Fixed
- Omits empty array parameters

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
