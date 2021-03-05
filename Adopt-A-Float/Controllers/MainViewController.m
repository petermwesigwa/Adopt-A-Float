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

    @property (strong) NSArray<NSString *> *organizationNames;
    @property (strong) NSMutableDictionary<NSString *, NSNumber*> *legendFilter;
@end

@implementation MainViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.appMapView.mapType = [[appStateManager.mapViewTypes objectAtIndex:
    appStateManager.selectedMapViewIndex] intValue];
}
/* use this to hide navigation bar*/
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

/* needed to enable navigation bar on other screens */
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.legendTableView.delegate = self;
    self.legendTableView.dataSource = self;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.optionsButton.layer.cornerRadius = 22.5;
    self.legendButton.layer.cornerRadius = 22.5;
    self.legendButton.layer.masksToBounds = YES;
    self.infoPanel.layer.cornerRadius = 20;
    self.titleButton.layer.cornerRadius = 20;
    self.zoomToUserButton.layer.cornerRadius = 27.5;
    self.zoomToMarkersButton.layer.cornerRadius = 27.5;
    self.infoPanel.layer.opacity = 0.99;
    self.infoPanel.layer.masksToBounds = YES;
    self.prevFloatButton.hidden = YES;
    self.nextFloatButton.hidden = YES;
    self.legendTableView.hidden = YES;
    self.legendTableView.layer.cornerRadius = 7.5;
    
    self.focusedOnMarkerIdx = -1;
    self.instrumentNames = [[instruments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.organizationNames = [organizations allKeys];
    
    
    // Create markers and paths for all positions of all floats
    self.markers = [[NSMutableDictionary alloc] init];
    self.onMarkers = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString *name in instrumentNames) {
        // make an array of markers and a path for each object
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        Instrument* instr = [instruments objectForKey:name];
        NSLog(@"%d", (int) instruments[name].dataPoints.count);
        
        //set icon
        UIImage *icon = [GMSMarker markerImageWithColor:[instr getColor]];
        for (DataPoint *row in [instr dataPoints]) {
            GMSMarker* marker = [self createMarkerWithData:row andIcon:icon];
            [markersForInstr addObject:marker];
        }
        [self.markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show most recent marker for instrument by default
    self.defaultMarkerNumber = 1;
    self.markerNumber = self.defaultMarkerNumber;
    self.legendFilter = [[NSMutableDictionary alloc] init];
    for (NSString *org in self.organizationNames) {
        self.legendFilter[org] = [NSNumber numberWithBool:YES];
    }
    
    // set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = 50;
    
    // mapview setup
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.0 longitude:0.0 zoom:1];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.appMapView.delegate = self;
    self.appMapView.camera = camera;
    // Defines the boundary around the edges of the instrument cluster
    self.appMapView.padding = UIEdgeInsetsMake(150, 25, 150, 25);
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
//            if (self.legendFilter[[ins getInstitution]]) {
//                [self instrumentSetup:ins];
//            }
            [self instrumentSetup:ins];
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
- (GMSMarker*)createMarkerWithData:(DataPoint*)data andIcon:(UIImage*)icon {
    GMSMarker *marker = [[GMSMarker alloc] init];

    marker.position = CLLocationCoordinate2DMake(data.gpsLat, data.gpsLon);
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
    NSLog(@"%@", instrument.name);
    NSLog(@"%d", (int) instrument.dataPoints.count);
    int n = self.markerNumber;
    if (n > [instrument.dataPoints count]) {
        n = (int) [instrument.dataPoints count];
    }
    
    for (int i = 0; i < n; i++) {
        float opac = 1 - (i/(n+1.0));
        [self turnOnMarker:[self.markers objectForKey:[instrument name]][i] withOpacity:opac];
    }
}

- (void) instrumentTakeDown:(Instrument*) old {
    // currently takes O(num_instruments x datapoints_per_instrument)
    NSLog(@"%@", old.name);
    NSLog(@"%d", (int) self.markers);
    for (GMSMarker* marker in [self.markers objectForKey:old.name]) {
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
    DataPoint *data = (DataPoint *) marker.userData;
    [iconView provideFloatData:data];
    iconView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    iconView.layer.cornerRadius = 15;
    iconView.layer.opacity = 0.98;
    iconView.accessibilityElementsHidden = NO;
    
    return iconView;
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.legendTableView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    self.legendTableView.hidden = YES;
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
    self.legendTableView.hidden = YES;
}

- (IBAction)toggleTableView:(id)sender {
    [self.appMapView setSelectedMarker:nil];
    if (_legendTableView.hidden) {
        _legendTableView.hidden = NO;
    } else {
        _legendTableView.hidden = YES;
    }
}

- (IBAction) backFromLegend:(UIStoryboardSegue *)unwindSegue {
    [self prepareInstrumentsForViewing];
}

- (IBAction) backFromOptions:(UIStoryboardSegue *)unwindSegue {
    // changes here handled in viewdidappear
}

- (IBAction) changeDisplayedInstrument:(UIStoryboardSegue *)unwindSegue {
    [self.legendFilter removeAllObjects];
    self.curr = [instruments objectForKey:appStateManager.selectedInstr];
    if (self.curr) {
        self.markerNumber = 30;
        self.legendTableView.allowsSelection = NO;
    } else {
        self.markerNumber = 1;
        self.legendTableView.allowsSelection = YES;
        for (NSString *org in _organizationNames) {
            _legendFilter[org] = [NSNumber numberWithBool:YES];
        }
    }
    [self prepareInstrumentsForViewing];
    [self.legendTableView reloadData];
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
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Permissions Denied" message:@"Enable in Settings -> Privacy -> Location"  preferredStyle:UIAlertControllerStyleAlert];
               
            UIAlertAction * alertButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                   [self.locationManager requestWhenInUseAuthorization];
               }];
               
            [alert addAction:alertButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        default:
            if (self.appMapView.myLocation) {
                [_appMapView setSelectedMarker:nil];
                GMSCameraUpdate *update = [GMSCameraUpdate setTarget:self.appMapView.myLocation.coordinate zoom:12];
                [self.appMapView animateWithCameraUpdate:update];
            }
            break;
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
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusNotDetermined:
            [manager stopUpdatingLocation];
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Location status is OK.");
            [manager startUpdatingLocation];
            self.appMapView.myLocationEnabled = YES;
    }
}
 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Permissions Denied" message:@"Enable in Settings -> Privacy -> Location"  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * alertButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self.locationManager requestWhenInUseAuthorization];
                }];
                
                [alert addAction:alertButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        case kCLAuthorizationStatusNotDetermined:
            [_locationManager requestWhenInUseAuthorization];
        default:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Error " message:error.localizedDescription  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * alertButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.locationManager requestWhenInUseAuthorization];
            }];
            
            [alert addAction:alertButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
}


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _organizationNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LegendCell"];
    NSString *orgName = _organizationNames[(int) indexPath.row];
    cell.textLabel.text = orgName;
    cell.imageView.image = [GMSMarker markerImageWithColor:organizations[orgName]];
    if (_legendFilter[orgName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *orgName = cell.textLabel.text;
    if (_legendFilter[orgName]) {
        [_legendFilter removeObjectForKey:orgName];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [_legendFilter setValue:[NSNumber numberWithBool:YES] forKey:orgName];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self prepareInstrumentsForViewing];
}
@end

