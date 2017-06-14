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

class PressureTest : QuickSpec {
    
    override func tearDown() {
        SwiftSky.units = UnitProfile()
        SwiftSky.locale = Locale.current
        super.tearDown()
    }
    
    override func setUp() {
        SwiftSky.locale = Locale(identifier: "en-US")
    }
    
    override func spec() {
        
        let pressure = Pressure(1000, withUnit: .millibar)
        describe("labels") {
            it("mb label should be") {
                expect(pressure.label).to(equal("1000 mb"))
            }
            it("hPa label should be") {
                expect(pressure.label(as: .hectopascal)).to(equal("1000 hPa"))
            }
            it("inHg label should be") {
                expect(pressure.label(as: .inchesOfMercury)).to(equal("29.5 inHg"))
            }
        }
        
        describe("conversions") {
            SwiftSky.units.pressure = .hectopascal
            let hPa = Pressure(1000, withUnit: .hectopascal)
            context("hPa to", {
                it("mb should be") {
                    expect(hPa.value(as: .millibar)).to(equal(1000))
                }
                it("hPa should be") {
                    expect(hPa.value(as: .hectopascal)).to(equal(1000))
                }
                it("inHg should be") {
                    expect(hPa.value(as: .inchesOfMercury)).to(equal(29.53))
                }
            })
            SwiftSky.units.pressure = .inchesOfMercury
            let inHg = Pressure(29.53, withUnit: .inchesOfMercury)
            context("m/s to", {
                it("mb should be") {
                    expect(inHg.value(as: .millibar)).to(equal(1000))
                }
                it("hPa should be") {
                    expect(inHg.value(as: .hectopascal)).to(equal(1000))
                }
                it("inHg should be") {
                    expect(inHg.value(as: .inchesOfMercury)).to(equal(29.53))
                }
            })
        }
        
    }
    
}
