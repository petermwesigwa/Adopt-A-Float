//
//  Adopt_A_FloatTests.m
//  Adopt-A-FloatTests
//
//  Created by William Ughetta on 2/10/18.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainViewController.h"
#import "DataUtility.h"
#import "AppState.h"

@interface Adopt_A_FloatTests : XCTestCase

@end

@implementation Adopt_A_FloatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    AppState *testAppState = [[AppState alloc] initWithInstruments:[DataUtility createInstruments]];
    XCTAssertTrue([testAppState.selectedInstr isEqualToString:@"All"]);
    XCTAssertEqual(testAppState.selectedInstrIndex,0);
    XCTAssertEqual(testAppState.selectedMapViewIndex,0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSMutableDictionary *instruments = [DataUtility createInstruments];
    }];
}

@end
