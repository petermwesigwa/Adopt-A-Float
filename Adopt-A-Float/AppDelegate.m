//
//  AppDelegate.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/8/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "AppDelegate.h"
#import "Instrument.h"
#import "getData.h"
#import <GoogleMaps/GoogleMaps.h>

NSMutableDictionary *instruments;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Get the Google Maps API Key from private.plist from the @"GoogleMapsAPIKey" row.
    // Get a new key from: https://developers.google.com/maps/documentation/ios-sdk/
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"plist"];
    NSDictionary *privateContents = [NSDictionary dictionaryWithContentsOfFile: privatePath];
    [GMSServices provideAPIKey:[privateContents objectForKey:@"GoogleMapsAPIKey"]];
    
    //Create the set of intrstruments if doesn't exist
    if (!instruments)
        instruments = [[NSMutableDictionary alloc] init];
        
    //update instrument data
    instruments = [getData getData:instruments];
    
    return YES;
}


@end
