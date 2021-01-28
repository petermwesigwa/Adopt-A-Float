//
//  Adopt_A_FloatUITests.m
//  Adopt-A-FloatUITests
//
//  Created by Peter Mwesigwa on 1/19/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

@interface Adopt_A_FloatUITests : XCTestCase

@end

@implementation Adopt_A_FloatUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitialization {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCTAssertTrue(app.buttons[@"All"].exists);

    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void) testChangingInstrument {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCTAssertTrue(app.buttons[@"All"].exists);
    [app.buttons[@"All"] tap];
    [app.tables.staticTexts[@"P008"] tap];
    XCTAssertTrue(!app.buttons[@"All"].exists);
    XCTAssertTrue(app.buttons[@"P008"].exists);
    [app.buttons[@"P008"] tap];
    [app.tables.staticTexts[@"P016"] tap];
    XCTAssertTrue(!app.buttons[@"P008"].exists);
    XCTAssertTrue(app.buttons[@"P016"].exists);
    [app.buttons[@"P016"] tap];
    [app.tables.staticTexts[@"P037"] tap];
    XCTAssertTrue(!app.buttons[@"P016"].exists);
    XCTAssertTrue(app.buttons[@"P037"].exists);
    
}

- (void) testMarkerInfoWindowSwipe {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    NSPredicate *identifyMarker = [NSPredicate predicateWithFormat:@"identifier BEGINSWITH[cd] 'GMSMarker'"];
    XCUIElement *marker = [[app.buttons matchingPredicate:identifyMarker] elementBoundByIndex:0];
    XCTAssertTrue(marker.exists);
    XCTAssertTrue(!app.buttons[@"arrowtriangle.right.fill"].exists);
    XCTAssertTrue(!app.buttons[@"arrowtriangle.left.fill"].exists);
    [marker tap];
        
//    XCTAssertTrue(app/*@START_MENU_TOKEN@*/.buttons[@"arrowtriangle.right.fill"]/*[[".otherElements[@\"MapView\"].buttons[@\"arrowtriangle.right.fill\"]",".buttons[@\"arrowtriangle.right.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists);
//    XCTAssertTrue(app.buttons[@"arrowtriangle.left.fill"].exists);
    for (int i = 0; i < 50; i++)
    {
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.buttons[@"arrowtriangle.right.fill"]/*[[".otherElements[@\"MapView\"].buttons[@\"arrowtriangle.right.fill\"]",".buttons[@\"arrowtriangle.right.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists);
        XCTAssertTrue(app.buttons[@"arrowtriangle.left.fill"].exists);
        [app/*@START_MENU_TOKEN@*/.buttons[@"arrowtriangle.right.fill"]/*[[".otherElements[@\"MapView\"].buttons[@\"arrowtriangle.right.fill\"]",".buttons[@\"arrowtriangle.right.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    }
    [marker tap];
    
    for (int i = 0; i < 50; i++)
    {
        [app.buttons[@"arrowtriangle.left.fill"] tap];
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.buttons[@"arrowtriangle.right.fill"]/*[[".otherElements[@\"MapView\"].buttons[@\"arrowtriangle.right.fill\"]",".buttons[@\"arrowtriangle.right.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists);
        XCTAssertTrue(app.buttons[@"arrowtriangle.left.fill"].exists);
    }

    [[[app/*@START_MENU_TOKEN@*/.otherElements[@"appMapView"]/*[[".otherElements[@\"MapView\"].otherElements[@\"appMapView\"]",".otherElements[@\"appMapView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ childrenMatchingType:XCUIElementTypeOther][@"Map"] childrenMatchingType:XCUIElementTypeOther][@"Map"] tap];
    XCTAssertTrue(!app/*@START_MENU_TOKEN@*/.buttons[@"arrowtriangle.right.fill"]/*[[".otherElements[@\"MapView\"].buttons[@\"arrowtriangle.right.fill\"]",".buttons[@\"arrowtriangle.right.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists);
    XCTAssertTrue(!app.buttons[@"arrowtriangle.left.fill"].exists);
}
- (void) testChangeMap {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
}

- (void) testLocationFeature {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
       default:
            XCTAssertTrue(app.buttons[@"location.circle"].exists);
            XCTAssertTrue(app.buttons[@"mappin"].exists);
            [app/*@START_MENU_TOKEN@*/.buttons[@"location.circle"]/*[[".otherElements[@\"MapView\"].buttons[@\"location.circle\"]",".buttons[@\"location.circle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
            [app/*@START_MENU_TOKEN@*/.buttons[@"mappin"]/*[[".otherElements[@\"MapView\"].buttons[@\"mappin\"]",".buttons[@\"mappin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
            
            break;
    }
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[XCTOSSignpostMetric.applicationLaunchMetric] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
