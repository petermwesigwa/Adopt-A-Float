//
//  MainViewController.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import "MainViewController.h"
#import "Instrument.h"
#import <GoogleMaps/GoogleMaps.h>

extern NSMutableDictionary* instruments;

@interface MainViewController ()

@end

@implementation MainViewController {
    GMSMapView *mapView_;
    __weak IBOutlet GMSMapView *appMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    Instrument* camIns;
    camIns = [instruments objectForKey:@"raffa"];
    float camLat = [camIns.lat[0] floatValue];
    float camLon = [camIns.lon[0] floatValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:camLat
                                                            longitude:camLon
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    appMapView.camera = camera;
    
    // Create markers for the first 5 data points
    for (int i = 0; i < 5; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([camIns.lat[i] floatValue], [camIns.lon[i] floatValue]);
        marker.title = camIns.name;
        marker.snippet = [[NSNumber numberWithInt:i] stringValue];
        marker.map = appMapView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
