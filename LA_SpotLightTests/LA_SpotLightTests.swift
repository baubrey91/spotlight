//
//  LA_SpotLightTests.swift
//  LA_SpotLightTests
//
//  Created by Brandon Aubrey on 9/27/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import XCTest
@testable import LA_SpotLight

class LA_SpotLightTests: XCTestCase {
    let dateOne = NSDate(timeIntervalSince1970: 10001)
    let dateTwo = NSDate(timeIntervalSince1970: 10000)
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGreaterDateExtension() {

        let result = dateOne.isGreaterThanDate(dateToCompare: dateTwo as Date)
        XCTAssert(result)
    }
    
    func testLessThanDateExtension() {
        let result = dateTwo.isLessThanDate(dateToCompare: dateOne as Date)
        XCTAssert(result)
    }
    
    func testEmpyFilmLocationsArray() {
        //let testFilm = FilmLocation(json: [String: Any]())
        let emptyArray = FilmLocation.filmLocations(array: [[String: Any]]())
        XCTAssertEqual(emptyArray.count, 0)
    }
}
