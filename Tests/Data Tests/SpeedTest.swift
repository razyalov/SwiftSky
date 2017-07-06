//
//  SpeedTest.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 11/04/2017.
//  Copyright © 2017 App Company.io. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftSky

class SpeedTest : QuickSpec {
    
    override func tearDown() {
        SwiftSky.units = UnitProfile()
        SwiftSky.locale = Locale.current
        super.tearDown()
    }
    
    override func setUp() {
        SwiftSky.locale = Locale(identifier: "en-US")
    }
    
    override func spec() {
        
        let mph = Speed(1, withUnit: .milePerHour)
        describe("labels") {
            it("mph label should be") {
                expect(mph.label).to(equal("1 mph"))
            }
            it("kph label should be") {
                expect(mph.label(as: .kilometerPerHour)).to(equal("2 kph"))
            }
            it("m/s label should be") {
                expect(mph.label(as: .meterPerSecond)).to(equal("0.4 m/s"))
            }
            it("kt label should be") {
                expect(mph.label(as: .knot)).to(equal("0.87 kt"))
            }
            it("bft label should be") {
                expect(mph.label(as: .beaufort)).to(equal("1 bft"))
            }
        }
        
        describe("conversions") {
            SwiftSky.units.speed = .kilometerPerHour
            let kph = Speed(10, withUnit: .kilometerPerHour)
            context("kph to", {
                it("kph should be") {
                    expect(kph.value(as: .kilometerPerHour)).to(equal(10))
                }
                it("mph should be") {
                    expect(kph.value(as: .milePerHour)).to(beCloseTo(6.2137))
                }
                it("m/s should be") {
                    expect(kph.value(as: .meterPerSecond)).to(beCloseTo(2.7778))
                }
                it("kt should be") {
                    expect(kph.value(as: .knot)).to(beCloseTo(5.3996))
                }
                it("bft should be") {
                    expect(kph.value(as: .beaufort)).to(equal(1))
                }
            })
            SwiftSky.units.speed = .meterPerSecond
            let ms = Speed(1, withUnit: .meterPerSecond)
            context("m/s to", {
                it("m/s should be") {
                    expect(ms.value(as: .meterPerSecond)).to(equal(1))
                }
                it("mph should be") {
                    expect(ms.value(as: .milePerHour)).to(beCloseTo(2.2369))
                }
                it("kph should be") {
                    expect(ms.value(as: .kilometerPerHour)).to(equal(3.6))
                }
                it("kt should be") {
                    expect(ms.value(as: .knot)).to(beCloseTo(1.9438))
                }
                it("bft should be") {
                    expect(ms.value(as: .beaufort)).to(equal(1))
                }
            })
            SwiftSky.units.speed = .knot
            let kt = Speed(1, withUnit: .knot)
            context("kt to", {
                it("m/s should be") {
                    expect(kt.value(as: .meterPerSecond)).to(beCloseTo(0.5144))
                }
                it("mph should be") {
                    expect(kt.value(as: .milePerHour)).to(beCloseTo(1.1508))
                }
                it("kph should be") {
                    expect(kt.value(as: .kilometerPerHour)).to(beCloseTo(1.8520))
                }
                it("kt should be") {
                    expect(kt.value(as: .knot)).to(equal(1))
                }
                it("bft should be") {
                    expect(kt.value(as: .beaufort)).to(equal(1))
                }
            })
            SwiftSky.units.speed = .beaufort
            let bft = Speed(10, withUnit: .beaufort)
            context("bft no conversion", {
                it("should be 10") {
                    expect(bft.value(as: .milePerHour)).to(equal(10))
                }
            })
            SwiftSky.units.speed = .kilometerPerHour
            let kmZero = Speed(0, withUnit: .kilometerPerHour)
            context("bft zero conversion", {
                it("should be 0") {
                    expect(kmZero.value(as: .beaufort)).to(equal(0))
                }
            })
        }
        
    }
    
}
