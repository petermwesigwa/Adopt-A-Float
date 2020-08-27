//
//  AppDelegate.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/8/15.
//  Modified by Peter Mwesigwa 08/19/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "AppDelegate.h"
/*
 This variable is used to store the intstruments and their data in order to be accesed by the
 map and is provided to the MainViewController after it it initialized in AppDelegate
 
 This is a dictionary where keys are instrument names and values are Instrument objects.
 Each instrument object contains an array of readings over its lifetime stored as
 FloatData objects
 */
NSMutableDictionary<NSString *, Instrument *> *instruments;

/*
 Each instrument belongs to a specific organization.
 
 Keys are organization names and values are the corresponding colors used to represent these
 organizations.
 
 Variable is intended to be used for the map legend
 */
NSMutableDictionary<NSString *, UIColor *> *organizations;

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 Called when the application first loads. This method is useful for handling setup tasks
 before the application starts running. Returns YES to signal success in running these
 tasks
 
 Currently this method is used to provide the Google API key needed to use Google maps and
 to fetch the instrument data to display on the map
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Get the Google Maps API Key from private.plist from the @"GoogleMapsAPIKey" row.
    // Provide this API key to the application to access Maps API from google
    // To get your API key visit: https://developers.google.com/maps/documentation/ios-sdk/
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"plist"];
    NSDictionary *privateContents = [NSDictionary dictionaryWithContentsOfFile: privatePath];
    [GMSServices provideAPIKey:[privateContents objectForKey:@"GoogleMapsAPIKey"]];
    
    // Create the instrumments with their reported data
    if (!instruments)
        instruments = [[NSMutableDictionary alloc] init];
    instruments = [DataUtility createInstruments];
    
    // 
    organizations = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[UIColor blueColor], @"GeoAzur", [UIColor yellowColor], @"SUSTech", [UIColor orangeColor], @"Princeton", [UIColor redColor], @"JAMSTEC", [UIColor grayColor], @"Inactive", nil];
    
    return YES;
}


@end
