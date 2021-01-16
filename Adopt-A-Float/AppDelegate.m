//
//  AppDelegate.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/8/15.
//  Modified by Peter Mwesigwa 08/19/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "AppDelegate.h"

AppState *appStateManager;
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


NSMutableDictionary<NSNumber *, NSString *> *mapTypes;

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
    
    if (!appStateManager) {
        appStateManager = [[AppState alloc] initWithInstruments:instruments];
    }
    
    // 
    organizations = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[UIColor blueColor], @"GeoAzur", [UIColor yellowColor], @"SUSTech", [UIColor orangeColor], @"Princeton", [UIColor redColor], @"JAMSTEC", [UIColor grayColor], @"Inactive", nil];
    
    mapTypes = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                    @"Satellite with labels", [NSNumber numberWithInt:kGMSTypeHybrid],
                     @"Satellite", [NSNumber numberWithInt:kGMSTypeSatellite],
                     @"Standard", [NSNumber numberWithInt:kGMSTypeNormal],
                     @"Terrain", [NSNumber numberWithInt:kGMSTypeTerrain],
                     nil];
    
    NSMutableDictionary *rawDataDict = [[NSMutableDictionary alloc] init];
    for (NSString *instrName in instruments) {
        [rawDataDict setObject:[instruments[instrName] getRaw] forKey:instrName];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appStateManager.selectedInstr forKey:@"Current Instrument"];
    [defaults setObject: (NSDictionary *) rawDataDict forKey:@"Instruments"];
    
//    [FloatData runTests];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    NSMutableDictionary *rawDataDict = [[NSMutableDictionary alloc] init];
    for (NSString *instrName in instruments) {
        [rawDataDict setObject:[instruments[instrName] getRaw] forKey:instrName];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appStateManager.selectedInstr forKey:@"Current Instrument"];
    [defaults setObject: (NSDictionary *) rawDataDict forKey:@"Instruments"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"Current Instrument"]){
        appStateManager.selectedInstr = [defaults objectForKey:@"Current Instrument"];
        NSLog(@"mykey found");
    }
    // Fetch instruments if not able to because of no server connection
    if ([instruments count] == 0) {
        instruments = [DataUtility createInstruments];
    }

    // If that fails, use the instruments that we already have stored
    if ([instruments count] == 0) {
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"Instruments"]){
            instruments = (NSMutableDictionary *)[[defaults objectForKey:@"Instruments"] mutableCopy];
        }
    }
}
@end
