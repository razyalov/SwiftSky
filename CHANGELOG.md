# Change Log
All notable changes to this project will be documented in this file.
`SwiftSky` adheres to [Semantic Versioning](http://semver.org/).

- `1.2.x` Release - [1.2.0](#120)
- `1.1.x` Releases - [1.1.0](#110) [1.1.1](#111)
- `1.0.x` Release - [1.0.0](#100)

---

## [1.2.0](https://github.com/appcompany/SwiftSky/releases/tag/1.2.0)

#### Added
- Added UV Index
- Added Wind Gust
- Added calculate `CLLocation` for a `Storm`
- Added Inches of Mercury as `PressureUnit` and implemented conversion accordingly in `Pressure`
  - Added by [Luca Silverentand](https://github.com/lucasilverentand)

#### Fixes
- Failing Unit Tests
  - Fixed by [Luca Silverentand](https://github.com/lucasilverentand)

## [1.1.1](https://github.com/appcompany/SwiftSky/releases/tag/1.1.1)

#### Fixes
- Fixed a bug where a faulty API key crashes SwiftSky
- Fixed a bug where the sunset would be sunrise in a `DataPoint`
    - Fixed by [Luca Silverentand](https://github.com/lucasilverentand)

## [1.1.0](https://github.com/appcompany/SwiftSky/releases/tag/1.1.0)

#### Added
- Exposed `Data` value on `Forecast`, for saving
- Function to create a `Forecast` from `Data`
- Function to create `Forecast` from `Forecast`, applying new unit settings
  - Added by [Luca Silverentand](https://github.com/lucasilverentand)


## [1.0.0](https://github.com/appcompany/SwiftSky/releases/tag/1.0.0)

#### Added
- Initial release of SwiftSky
  - Added by [Luca Silverentand](https://github.com/lucasilverentand)
