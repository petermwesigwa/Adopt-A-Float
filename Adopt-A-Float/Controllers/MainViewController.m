//
//  MainViewController.m
//  Adopt-A-Float
//
//  Last modified by Peter Mwesigwa on 01/22/2021
//  Created by Ben Leizman on 6/20/15
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import "MainViewController.h"
#import "OptionsViewController.h"

/*
 This is an effort to maintain state in one place that is accessible throughout the application.
 
 */
extern AppState *appStateManager;


/*
 This dictionary contains each of the instruments and the data that they have recorded
 All the instrument setup and population of the data therein happens in the AppDelegate.m
 file.
 */
extern NSMutableDictionary<NSString *, Instrument *> *instruments;

/*
This dictionary con.
*/
extern NSMutableDictionary<NSString *, UIColor*> *organizations;

@interface MainViewController ()
    /* bounds used to display all visible markers */
    @property (strong) GMSCoordinateBounds *instrumentBounds;

    /* index to locate currently displayed marker in self.onMarkers, -1 if none selected */
    @property (assign) int focusedOnMarkerIdx;
    @property (assign) BOOL isSwipingBetweenMarkers;
@end

@implementation MainViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.appMapView.mapType = [[appStateManager.mapViewTypes objectAtIndex:
    appStateManager.selectedMapViewIndex] intValue];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //to make status bar white
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.optionsButton.layer.cornerRadius = 22.5;
    self.legendButton.layer.cornerRadius = 22.5;
    self.infoPanel.layer.cornerRadius = 20;
    self.titleButton.layer.cornerRadius = 20;
    self.zoomToUserButton.layer.cornerRadius = 27.5;
    self.zoomToMarkersButton.layer.cornerRadius = 27.5;
    self.infoPanel.layer.opacity = 0.99;
    self.infoPanel.layer.masksToBounds = YES;
    self.prevFloatButton.hidden = YES;
    self.nextFloatButton.hidden = YES;
    self.focusedOnMarkerIdx = -1;
    
    self.instrumentNames = [[instruments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    // Create markers and paths for all positions of all floats
    self.markers = [[NSMutableDictionary alloc] init];
    self.onMarkers = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString *name in instrumentNames) {
        
        // make an array of markers and a path for each object
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        Instrument* instr = [instruments objectForKey:name];
        
        //set icon
        UIImage *icon = [GMSMarker markerImageWithColor:[instr getColor]];
        for (FloatData *row in [instr getFloatData]) {
            GMSMarker* marker = [self createMarkerWithData:row andIcon:icon];
            [markersForInstr addObject:marker];
        }
        [self.markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show most recent marker for instrument by default
    self.defaultMarkerNumber = 1;
    self.markerNumber = self.defaultMarkerNumber;
    
    // set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    
    // mapview setup
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.0 longitude:0.0 zoom:1];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.appMapView.delegate = self;
    self.appMapView.camera = camera;
    // Defines the boundary around the edges of the instrument cluster
    self.appMapView.padding = UIEdgeInsetsMake(150, 25, 70, 25);
    self.appMapView.accessibilityElementsHidden = NO;
    self.view.accessibilityIdentifier = @"MapView";
    self.appMapView.accessibilityIdentifier = @"appMapView";
    self.appMapView.accessibilityLabel = @"Map";
    
    [self prepareInstrumentsForViewing];
}

- (void) prepareInstrumentsForViewing {
    for (Instrument *ins in [instruments allValues]) {
        [self instrumentTakeDown:ins];
    }
    
    if (self.curr) {
        [self instrumentSetup:self.curr];
    } else {
        for (NSString *instrName in appStateManager.instrNames) {
            Instrument* ins = instruments[instrName];
            if (![appStateManager.orgFilters objectForKey:[ins getInstitution]]) {
                [self instrumentSetup:ins];
            }
        }
    }
    [self.titleButton setTitle:appStateManager.selectedInstr forState:UIControlStateNormal];
    
    [self addOnMarkersToMap];
    
    self.instrumentBounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in self.onMarkers) {
        if (![_instrumentBounds isValid]) {
            _instrumentBounds = [_instrumentBounds initWithCoordinate:marker.position coordinate:marker.position];
        } else {
            _instrumentBounds = [_instrumentBounds includingCoordinate:marker.position];
        }
    }
    
    [self updateCameraPositionWithAnimation:YES];
}

// moves google map camera to display the floats currently in focus
- (void) updateCameraPositionWithAnimation:(BOOL)animation {
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:_instrumentBounds withPadding:15.0];
    if (animation == NO)
        [self.appMapView moveCamera:update];
    else [self.appMapView animateWithCameraUpdate:update];
}

// Creates a GMSmarker for each FloatData object
- (GMSMarker*)createMarkerWithData:(FloatData*)data andIcon:(UIImage*)icon {
    GMSMarker *marker = [[GMSMarker alloc] init];

    marker.position = CLLocationCoordinate2DMake([data.gpsLat floatValue], [data.gpsLon floatValue]);
    marker.infoWindowAnchor = CGPointMake(0.5f, 0.5f);
    marker.map = nil;
    marker.icon = icon;
    marker.userData = data;
    
    
    return marker;
}

- (void)turnOffMarker:(GMSMarker*) marker {
    marker.map = nil;
    [self.onMarkers removeObject:marker];
}

- (void)turnOnMarker:(GMSMarker*) marker withOpacity:(float)opac {
    marker.opacity = opac;
    [self.onMarkers addObject:marker];
}

- (void) addOnMarkersToMap {
    for (GMSMarker* marker in self.onMarkers) {
        marker.map = self.appMapView;
        marker.appearAnimation = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clearOnMarkers {
    while (self.onMarkers.count > 0)
        [self turnOffMarker:[self.onMarkers lastObject]];
}

/*
 Prepares an instrument that has been selected for display
 Turns on the instrument marker and the line joining them
 */
- (void) instrumentSetup:(Instrument*)instrument {
    //Turn on new markers and make new path
    int n = self.markerNumber;
    if (n > [[instrument getFloatData] count]) {
        n = (int) [[instrument getFloatData] count];
    }
    
    for (int i = 0; i < n; i++) {
        float opac = 1 - (i/(n+1.0));
        [self turnOnMarker:[self.markers objectForKey:[instrument getName]][i] withOpacity:opac];
    }
}

- (void) instrumentTakeDown:(Instrument*) old {
    // currently takes O(num_instruments x datapoints_per_instrument)
    for (GMSMarker* marker in [self.markers objectForKey:[old getName]]) {
        [self turnOffMarker:marker];
    }
}

/* retrieve array position for marker in on marker array, -1 if not found*/
- (int) indexForOnMarker:(GMSMarker *)onMarker {
    for (int i = 0; i < self.onMarkers.count; i++) {
        if (self.onMarkers[i] == onMarker) {
            return i;
        }
    }
    return -1;
}

#pragma mark GMSMapViewDelegate

// Displays custom marker icon info window with all the mermaid data
- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    if (self.focusedOnMarkerIdx == -1) {
        self.focusedOnMarkerIdx = [self indexForOnMarker:marker];
    }
    self.nextFloatButton.hidden = NO;
    self.prevFloatButton.hidden = NO;
    
     mapIconView *iconView = [[[NSBundle mainBundle] loadNibNamed:@"mapmarkericonview" owner:self options:nil] objectAtIndex:0];
    FloatData *data = (FloatData *) marker.userData;
    [iconView provideFloatData:data];
    iconView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    iconView.layer.cornerRadius = 15;
    iconView.layer.opacity = 0.98;
    iconView.accessibilityElementsHidden = NO;
    
    return iconView;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    self.focusedOnMarkerIdx = [self indexForOnMarker:marker];
    return NO;
}

-(void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(nonnull GMSMarker *)marker {
    self.focusedOnMarkerIdx = -1;
    self.nextFloatButton.hidden = YES;
    self.prevFloatButton.hidden = YES;
}

# pragma mark - Segues and Actions
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction) backFromLegend:(UIStoryboardSegue *)unwindSegue {
    [self prepareInstrumentsForViewing];
}

- (IBAction) backFromOptions:(UIStoryboardSegue *)unwindSegue {
    // changes here handled in viewdidappear
}

- (IBAction) changeDisplayedInstrument:(UIStoryboardSegue *)unwindSegue {
    self.curr = [instruments objectForKey:appStateManager.selectedInstr];
    if (self.curr) {
        self.markerNumber = 30;
        [appStateManager.orgFilters removeAllObjects];
    } else {
        self.markerNumber = 1;
    }
    [self prepareInstrumentsForViewing];
}
- (IBAction)discardChanges:(UIStoryboardSegue *)unwindSegue {
    // do nothing here
}
/* called when user clicks on zoomToMarkers Button */
- (IBAction)markerFocus:(id)sender {
    [self updateCameraPositionWithAnimation:YES];
}
/* Called when user clicks on the zoomToUser button */
- (IBAction)userFocus:(id)sender {
    if (self.appMapView.myLocation) {
        [_appMapView setSelectedMarker:nil];
        GMSCameraUpdate *update = [GMSCameraUpdate setTarget:self.appMapView.myLocation.coordinate zoom:12];
        [self.appMapView animateWithCameraUpdate:update];
    }
}
/* Called when user clicks on right arrow*/
- (IBAction)showNextMarkerinSequence:(id)sender {
    if (_focusedOnMarkerIdx == (int)_onMarkers.count - 1) {
        _focusedOnMarkerIdx = 0;
    } else {
        _focusedOnMarkerIdx += 1;
    }
    GMSMarker* nextMarker = _onMarkers[_focusedOnMarkerIdx];
    [_appMapView setSelectedMarker:nextMarker];
    [_appMapView animateToLocation:nextMarker.position];
    self.nextFloatButton.hidden = NO;
    self.prevFloatButton.hidden = NO;
}
/* called when user clicks on left arrow */
- (IBAction)showPrevMarkerInSequence:(id)sender {
    if (_focusedOnMarkerIdx == 0) {
        _focusedOnMarkerIdx = (int)_onMarkers.count - 1;
   } else {
       _focusedOnMarkerIdx -= 1;
   }
    GMSMarker *prevMarker = _onMarkers[_focusedOnMarkerIdx];
    [_appMapView setSelectedMarker:prevMarker];
    [_appMapView animateToLocation:prevMarker.position];
    self.nextFloatButton.hidden = NO;
    self.prevFloatButton.hidden = NO;
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
      case kCLAuthorizationStatusRestricted:
        NSLog(@"Location access was restricted.");
        break;
      case kCLAuthorizationStatusDenied:
        NSLog(@"User denied access to location.");
      case kCLAuthorizationStatusNotDetermined:
        NSLog(@"Location status not determined.");
      case kCLAuthorizationStatusAuthorizedAlways:
      case kCLAuthorizationStatusAuthorizedWhenInUse:
        NSLog(@"Location status is OK.");
        self.appMapView.myLocationEnabled = YES;
    }
}
 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *locationAlert = [UIAlertController alertControllerWithTitle:@"Location Error " message:error.localizedDescription  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *allowLocation = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.locationManager requestWhenInUseAuthorization];
    }];
    UIAlertAction *denyLocation = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    [locationAlert addAction:allowLocation];
    [locationAlert addAction:denyLocation];
    [self presentViewController:locationAlert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
}
@end

