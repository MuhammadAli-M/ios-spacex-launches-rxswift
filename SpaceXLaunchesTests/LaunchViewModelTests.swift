//
//  LaunchViewModelTests.swift
//  SpaceXLaunchesTests
//
//  Created by Muhammad Adam on 20/11/2021.
//

import XCTest
@testable import SpaceXLaunches

class LaunchViewModelTests: XCTestCase {
    
    func testSuccessful_withIconLinks(){
        
        let actual = Launch.stubLinks(linksCount: 4, upcoming: false)
        
        let expectedVM = actual.map{ LaunchViewModel($0)}
        let hasIcons = expectedVM.filter{ $0.iconPath.isEmpty == false }
        XCTAssertTrue(hasIcons.isEmpty, "Successful Launches should not have icon links")
    }
    
    func testUpcoming_withIconLinks(){
        let actual = Launch.stubHasIcon_Upcoming()
        let expected = LaunchViewModel(actual)
        
        XCTAssertFalse(expected.iconPath.isEmpty, "Upcoming Launches should keep received icon links")
    }
}

extension Launch{
    static func stubHasIcon_Upcoming() -> Launch{
        Launch(name: "Test 1",
               number: 1,
               date: Date(timeIntervalSince1970: 0),
               details: "Test details",
               icon: "https://farm9.staticflickr.com/8747/16581738577_83e0690136_o.png",
               upcoming: true,
               rocketID: "12345")
    }
    
    static func stubLinks(linksCount: Int, upcoming: Bool) -> [Launch]{
        Range(1...linksCount).map{ number in
            return Launch(name: "Test \(number)",
                          number: number,
                          date: Date(timeIntervalSince1970: 0),
                          details: "Test details",
                          icon: "https://farm9.staticflickr.com/8747/16581738577_83e0690136_o.png",
                          upcoming: upcoming,
                          rocketID: "12345")
        }
    }
}
