//
//  MainTest.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 11/04/2017.
//  Copyright © 2017 App Company.io. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
import CoreLocation
import Alamofire
@testable import SwiftSky

class EmptyForecastTest : QuickSpec {
    
    override func spec() {
        describe("no header request") {
            it("should be", closure: { 
                let forecast = Forecast(nil, headers: nil)
                expect(forecast.alerts).to(beNil())
                expect(forecast.current).to(beNil())
                expect(forecast.days).to(beNil())
                expect(forecast.hours).to(beNil())
                expect(forecast.minutes).to(beNil())
                expect(forecast.timezone).to(beNil())
                expect(forecast.location).to(beNil())
                expect(forecast.metadata).to(beNil())
            })
        }
    }
    
}

class EmptyLocationTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func spec() {
        describe("empty location") {
            it("should be", closure: {
                SwiftSky.secret = "fake_key"
                var success = true
                waitUntil(timeout: 10) { done in
                    SwiftSky.get([.current], at: "") { result in
                        switch result {
                        case .success:
                            success = true
                        case .failure:
                            success = false
                        }
                        done()
                    }
                }
                expect(success).to(equal(false))
            })
        }
    }
    
}

class NoSecretTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func spec() {
        describe("empty location") {
            it("should be", closure: {
                var success = true
                waitUntil(timeout: 10) { done in
                    SwiftSky.get([.current], at: "0,0") { result in
                        switch result {
                        case .success:
                            success = true
                        case .failure:
                            success = false
                        }
                        done()
                    }
                }
                expect(success).to(equal(false))
            })
        }
    }
    
}

class NoDataRequest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func spec() {
        describe("empty location") {
            it("should be", closure: {
                SwiftSky.secret = "fake_key"
                var success = true
                waitUntil(timeout: 10) { done in
                    SwiftSky.get([], at: "0,0") { result in
                        switch result {
                        case .success:
                            success = true
                        case .failure:
                            success = false
                        }
                        done()
                    }
                }
                expect(success).to(equal(false))
            })
        }
    }
    
}

class NonGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func spec() {
        describe("failing get") {
            it("should be", closure: {
                
                SwiftSky.secret = "fake_key"
                var success = true
                waitUntil(timeout: 10) { done in
                    let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                    SwiftSky.get([.current], at: location) { result in
                        switch result {
                        case .success:
                            success = true
                        case .failure:
                            success = false
                        }
                        done()
                    }
                }
                expect(success).to(equal(false))
                
            })
        }
    }
    
}

class ServerErrorGet : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        SwiftSky.secret = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast_fail.json", type(of: self))!,
                status: 500,
                headers: ["Content-Type":"application/json", "X-Forecast-API-Calls":"1", "X-Response-Time":"0.5"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("regular", {
                it("should load", closure: {
                    SwiftSky.secret = "fake_key"
                    var success = false
                    waitUntil(timeout: 10) { done in
                        let location = Location(latitude: self.latitude, longitude: self.longitude).asLocation()!
                        SwiftSky.get([.current], at: location) { result in
                            switch result {
                            case .success:
                                success = true
                            case .failure:
                                success = false
                            }
                            done()
                        }
                    }
                    expect(success).to(equal(false))
                })
            })
        }
    }
}

class NoInternetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        SwiftSky.secret = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            return OHHTTPStubsResponse(error:notConnectedError)
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("regular", {
                it("should load", closure: {
                    SwiftSky.secret = "fake_key"
                    var success = false
                    var response : Forecast? = nil
                    var error : ApiError? = nil
                    waitUntil(timeout: 10) { done in
                        let location = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            switch result {
                            case .success:
                                success = true
                            case .failure:
                                success = false
                            }
                            response = result.response
                            error = result.error
                            done()
                        }
                    }
                    expect(success).to(equal(false))
                    expect(error).notTo(beNil())
                    expect(response).to(beNil())
                })
            })
        }
    }
}

class RegularGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        SwiftSky.secret = nil
        SwiftSky.units.temperature = .fahrenheit
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast.json", type(of: self))!,
                headers: ["Content-Type":"application/json", "X-Forecast-API-Calls":"1", "X-Response-Time":"0.5"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("regular", { 
                it("should load", closure: {
                    SwiftSky.secret = "fake_key"
                    var response : Forecast? = nil
                    var error : ApiError? = nil
                    waitUntil(timeout: 10) { done in
                        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            response = result.response
                            error = result.error
                            done()
                        }
                    }
                    
                    expect(response?.current?.temperature?.current?.value).to(equal(48.71))
                    expect(Forecast(data: response?.data).current?.temperature?.current?.value).to(equal(48.71))
                    
                    let wrong : [String : Any?] = ["josn":nil,"headers":nil]
                    expect(Forecast(data: NSKeyedArchiver.archivedData(withRootObject: wrong))).notTo(beNil())
                    expect(Forecast(data: nil)).notTo(beNil())
                    
                    SwiftSky.units.temperature = .celsius
                    expect(response?.reloadSettings()?.current?.temperature?.current?.value).to(equal((48.71 - 32) * (5/9)))
                    
                    expect(response).notTo(beNil())
                    expect(error).to(beNil())
                })
            })
        }
    }

}

class NoHeaderGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        SwiftSky.secret = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast.json", type(of: self))!,
                headers: ["Content-Type":"application/json"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("no header", {
                it("should load", closure: {
                    SwiftSky.secret = "fake_key"
                    var success = false
                    waitUntil(timeout: 10) { done in
                        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            switch result {
                            case .success:
                                success = true
                            case .failure:
                                success = false
                            }
                            done()
                        }
                    }
                    expect(success).to(equal(true))
                })
            })
        }
    }
    
}

class BareMinimumGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        SwiftSky.secret = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast_bare.json", type(of: self))!,
                headers: ["Content-Type":"application/json", "X-Forecast-API-Calls":"1", "X-Response-Time":"0.5"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("bare minimum", {
                it("should load", closure: {
                    SwiftSky.secret = "fake_key"
                    var success = false
                    waitUntil(timeout: 10) { done in
                        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            switch result {
                            case .success:
                                success = true
                            case .failure:
                                success = false
                            }
                            done()
                        }
                    }
                    expect(success).to(equal(true))
                })
            })
        }
    }
    
}

class NoApiKeyGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        SwiftSky.secret = nil
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast.json", type(of: self))!,
                headers: ["Content-Type":"application/json","X-Forecast-API-Calls":"1","X-Response-Time":"0.5"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("no api key", {
                it("should load", closure: {
                    var response : Forecast? = nil
                    var error : ApiError? = nil
                    waitUntil(timeout: 10) { done in
                        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            response = result.response
                            error = result.error
                            done()
                        }
                    }
                    expect(response).to(beNil())
                    expect(error).toNot(beNil())
                })
            })
        }
    }
    
}

class WrongApiKeyGetTest : QuickSpec {
    
    let latitude = 47.20296790272209
    let longitude = -123.41670367098749
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    override func setUp() {
        SwiftSky.secret = "2345jkkj89*jkw3rn  njk ih 983 89y3 98ybq3<>"
        _ = stub(condition: isHost("api.darksky.net")) { _ in
            return fixture(
                filePath: OHPathForFile("forecast.json", type(of: self))!,
                headers: ["Content-Type":"application/json","X-Forecast-API-Calls":"1","X-Response-Time":"0.5"]
            )
        }
        super.setUp()
    }
    
    override func spec() {
        describe("getting forecast") {
            context("wrong api key", {
                it("should not load", closure: {
                    var response : Forecast? = nil
                    var error : ApiError? = nil
                    waitUntil(timeout: 10) { done in
                        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
                        SwiftSky.get([.current], at: location) { result in
                            response = result.response
                            error = result.error
                            done()
                        }
                    }
                    expect(response).to(beNil())
                    expect(error).toNot(beNil())
                })
            })
        }
    }
    
}
