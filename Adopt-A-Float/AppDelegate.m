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
    
    // TODO: Remove hard-coded APIKey
    [GMSServices provideAPIKey:@"AIzaSyANYDMiNKs6R6eJmQfki8igApPrnzgkET8"];
    // Override point for customization after application launch.
    
    //Create the set of intrstruments if doesn't exist
    if (!instruments)
        instruments = [[NSMutableDictionary alloc] init];
        
    //update instrument data
    instruments = [getData getData:instruments];
    
    return YES;
}


@end
