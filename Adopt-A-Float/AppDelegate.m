//
//  AppDelegate.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/8/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import "AppDelegate.h"
#import "Instrument.h"
#import <GoogleMaps/GoogleMaps.h>

NSMutableDictionary *instruments;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:@"AIzaSyANYDMiNKs6R6eJmQfki8igApPrnzgkET8"];
    // Override point for customization after application launch.
    
    //Create the set of intrstruments if doesn't exist
    if (!instruments)
        instruments = [[NSMutableDictionary alloc] init];
    
    // Hardwire coordinates (just for now) (see python program for how I got them)
    NSArray *lonRaffa = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-64.67376709], [NSNumber numberWithFloat:-64.44495272], [NSNumber numberWithFloat:-64.30903689], [NSNumber numberWithFloat:-64.30557581], [NSNumber numberWithFloat:-64.26360183], [NSNumber numberWithFloat:-64.19727214], [NSNumber numberWithFloat:-64.09671235], [NSNumber numberWithFloat:-64.06193689], [NSNumber numberWithFloat:-63.74066703], [NSNumber numberWithFloat:-63.51913755], [NSNumber numberWithFloat:-63.51371962], [NSNumber numberWithFloat:-63.44720067], [NSNumber numberWithFloat:-63.2409576], [NSNumber numberWithFloat:-63.11549568], [NSNumber numberWithFloat:-63.04995181], [NSNumber numberWithFloat:-62.83452571], [NSNumber numberWithFloat:-62.74190995], [NSNumber numberWithFloat:-62.64867614], [NSNumber numberWithFloat:-62.44863952], [NSNumber numberWithFloat:-62.34062274], [NSNumber numberWithFloat:-61.96676187], [NSNumber numberWithFloat:-61.67655471], [NSNumber numberWithFloat:-61.5834078], [NSNumber numberWithFloat:-61.47707522], [NSNumber numberWithFloat:-61.38182528], [NSNumber numberWithFloat:-61.15265907], [NSNumber numberWithFloat:-61.07876972], [NSNumber numberWithFloat:-61.05148333], [NSNumber numberWithFloat:-60.89784303], [NSNumber numberWithFloat:-60.60853857], [NSNumber numberWithFloat:-60.66624886], nil];
    NSArray *latRaffa = [NSArray arrayWithObjects:[NSNumber numberWithFloat:32.40634227], [NSNumber numberWithFloat:32.46816267], [NSNumber numberWithFloat:32.6718331], [NSNumber numberWithFloat:32.88978819], [NSNumber numberWithFloat:32.88895872], [NSNumber numberWithFloat:33.05039024], [NSNumber numberWithFloat:33.21788912], [NSNumber numberWithFloat:33.44471636], [NSNumber numberWithFloat:33.44616126], [NSNumber numberWithFloat:33.57984305], [NSNumber numberWithFloat:33.81678448], [NSNumber numberWithFloat:33.79387338], [NSNumber numberWithFloat:33.90195377], [NSNumber numberWithFloat:34.37737037], [NSNumber numberWithFloat:34.28274664], [NSNumber numberWithFloat:34.34912836], [NSNumber numberWithFloat:34.64296778], [NSNumber numberWithFloat:34.76472211], [NSNumber numberWithFloat:34.9927229], [NSNumber numberWithFloat:34.96043153], [NSNumber numberWithFloat:35.12573055], [NSNumber numberWithFloat:35.38186241], [NSNumber numberWithFloat:35.52517503], [NSNumber numberWithFloat:35.79055946], [NSNumber numberWithFloat:35.91117423], [NSNumber numberWithFloat:35.9120783], [NSNumber numberWithFloat:36.07440082], [NSNumber numberWithFloat:36.18035313], [NSNumber numberWithFloat:36.36772039], [NSNumber numberWithFloat:36.44917381], [NSNumber numberWithFloat:36.63084465], nil];
    NSArray *lonRobin = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-64.88079071], [NSNumber numberWithFloat:-64.64665054], [NSNumber numberWithFloat:-64.60638853], [NSNumber numberWithFloat:-64.54543015], [NSNumber numberWithFloat:-64.66597319], [NSNumber numberWithFloat:-64.42597082], [NSNumber numberWithFloat:-64.2137747], [NSNumber numberWithFloat:-64.09512549], [NSNumber numberWithFloat:-64.00221566], [NSNumber numberWithFloat:-63.70636738], [NSNumber numberWithFloat:-63.57026735], [NSNumber numberWithFloat:-63.45693166], [NSNumber numberWithFloat:-63.2994928], [NSNumber numberWithFloat:-63.23051259], [NSNumber numberWithFloat:-63.18889164], [NSNumber numberWithFloat:-63.14275116], [NSNumber numberWithFloat:-63.02370447], [NSNumber numberWithFloat:-63.0005753], [NSNumber numberWithFloat:-62.80980964], [NSNumber numberWithFloat:-62.56199798], [NSNumber numberWithFloat:-62.51098966], [NSNumber numberWithFloat:-62.39277866], [NSNumber numberWithFloat:-62.11539512], [NSNumber numberWithFloat:-61.93918572], [NSNumber numberWithFloat:-61.89751349], [NSNumber numberWithFloat:-61.8285996], [NSNumber numberWithFloat:-61.57641901], [NSNumber numberWithFloat:-61.24728691], [NSNumber numberWithFloat:-60.94465381], [NSNumber numberWithFloat:-60.82548992], [NSNumber numberWithFloat:-60.82025961], nil];
    NSArray *latRobin = [NSArray arrayWithObjects:[NSNumber numberWithFloat:32.32253485], [NSNumber numberWithFloat:32.55406395], [NSNumber numberWithFloat:32.74084086], [NSNumber numberWithFloat:33.0966131], [NSNumber numberWithFloat:33.32179166], [NSNumber numberWithFloat:33.5660654], [NSNumber numberWithFloat:33.69581062], [NSNumber numberWithFloat:33.72580145], [NSNumber numberWithFloat:33.69710254], [NSNumber numberWithFloat:33.93563737], [NSNumber numberWithFloat:34.10906569], [NSNumber numberWithFloat:34.20625329], [NSNumber numberWithFloat:34.27765948], [NSNumber numberWithFloat:34.51461111], [NSNumber numberWithFloat:34.7238303], [NSNumber numberWithFloat:34.99205281], [NSNumber numberWithFloat:35.27384779], [NSNumber numberWithFloat:35.45891754], [NSNumber numberWithFloat:35.46810343], [NSNumber numberWithFloat:35.40107056], [NSNumber numberWithFloat:35.62964254], [NSNumber numberWithFloat:35.80729093], [NSNumber numberWithFloat:35.95776498], [NSNumber numberWithFloat:36.01118665], [NSNumber numberWithFloat:36.03342385], [NSNumber numberWithFloat:36.22768264], [NSNumber numberWithFloat:36.51571571], [NSNumber numberWithFloat:36.64302033], [NSNumber numberWithFloat:36.98007379], [NSNumber numberWithFloat:36.94588127], [NSNumber numberWithFloat:37.06564616], nil];
    
    // If no objects exist under name, create new object
    if(![instruments objectForKey:@"raffa"]) {
        NSLog(@"Doesn't contains raffa");
        Instrument *raffa = [[Instrument alloc] initWithName:@"raffa" andLat:latRaffa andLon:lonRaffa];
        [instruments setObject:raffa forKey:@"raffa"];
    }
    if(![instruments objectForKey:@"robin"]) {
        NSLog(@"Doesn't contains robin");
        Instrument *robin = [[Instrument alloc] initWithName:@"robin" andLat:latRobin andLon:lonRobin];
        [instruments setObject:robin forKey:@"robin"];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
