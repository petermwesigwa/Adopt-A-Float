//
//  MainViewController.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Modified by Peter Mwesigwa on 8/18/20.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "MainViewController.h"
#import "OptionsViewController.h"


/*
 This dictionary contains each of the instruments and the data that they have recorded
 All the instrument setup and population of the data therein happens in the AppDelegate.m
 file.
 */
extern NSMutableDictionary<NSString *, Instrument *> *instruments;

@implementation MainViewController


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //take down all visible instruments
    for (Instrument *ins in [instruments allValues]) {
        [self instrumentTakeDown:ins];
    }
    
    // if instrument is chosen set it up
    if (self.curr) {
        [self instrumentSetup:self.curr];
        self.navigationItem.title = [self.curr getName];
    }
    
    // otherwise display all the instruments
    else {
        for (Instrument *ins in [instruments allValues]) {
            [self instrumentSetup:ins];
        }
        self.navigationItem.title = @"All";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //to make status bar white
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Basic initializations
    self.polylineStrokeWidth = 3;
    
    self.instrumentNames = [[instruments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.currentFloatIndex = 0;
    
    //Make colors array
    self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor blackColor], [UIColor grayColor], [UIColor whiteColor], [UIColor darkGrayColor], [UIColor lightGrayColor]];

    
    // Create markers and paths for all positions of all floats
    self.markers = [[NSMutableDictionary alloc] init];
    self.mutablePaths = [[NSMutableDictionary alloc] init];
    self.onMarkers = [[NSMutableArray alloc] init];
    self.onPolylines = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString *name in instrumentNames) {

        //set icon color
//        if (j == self.colors.count) j = 0; //to make sure there's no overflow
//        UIImage *icon = [GMSMarker markerImageWithColor:[UIColor grayColor]];
//
        
        // make an array of markers and a path for each object
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        GMSMutablePath *newPath = [GMSMutablePath path];
        int i = 0;
        Instrument* instr = [instruments objectForKey:name];
        
        //set icon
        UIImage *icon = [GMSMarker markerImageWithColor:[instr getColor]];
        for (FloatData *row in [instr getFloatData]) {
            
            //Create new marker and add to marker array
            GMSMarker* marker;
            bool gps = !([row.gpsLon floatValue] == 0); //if equal to 0, then NaN
            if (!gps) {
                marker = [self createMarkerWithData:row andIcon:icon];
            }
            else {
                marker = [self createMarkerWithData:row andIcon:icon];
            }
            [markersForInstr addObject:marker];
            
            //Add location to path
            if (gps) {
                [newPath addLatitude:[row.gpsLat doubleValue] longitude:[row.gpsLon doubleValue]];
            }
            else {
                [newPath addLatitude:[row.gpsLon doubleValue] longitude:[row.gpsLon doubleValue]];
            }
            i++;
        }
        [self.mutablePaths setObject:newPath forKey:name];
        [self.markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show most recent marker for instrument by default
    self.defaultMarkerNumber = 1;
    self.markerNumber = self.defaultMarkerNumber;
    
    for (Instrument *ins in [instruments allValues]) {
        [self instrumentSetup:ins];
    }
    
    self.navigationItem.title = @"All";
    
    
    // Create a GMSCameraPosition for the initial camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.0 longitude:0.0 zoom:1];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.appMapView.delegate = self;
    self.appMapView.camera = camera;
    self.appMapView.mapType = kGMSTypeHybrid;
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:NO];
}

- (void) updateCameraPositionWithAnimation:(BOOL)animation {
    double lonMin = MAXFLOAT;
    double lonMax = -MAXFLOAT;
    double latMin = MAXFLOAT;
    double latMax = -MAXFLOAT;
    for (GMSMarker *marker in self.onMarkers) {
        if (marker.position.longitude < lonMin)
            lonMin = marker.position.longitude;
        if (marker.position.longitude > lonMax)
            lonMax = marker.position.longitude;
        if (marker.position.latitude < latMin)
            latMin = marker.position.latitude;
        if (marker.position.latitude > latMax)
            latMax = marker.position.latitude;
    }
    
    // Attetion: relating to which coord is more east and which is more west (wraparound)
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(latMax, lonMax);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(latMin, lonMin);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    if (animation == NO)
        [self.appMapView moveCamera:update];
    else [self.appMapView animateWithCameraUpdate:update];
}

// Creates a GMSmarker for each FloatData object
- (GMSMarker*)createMarkerWithData:(FloatData*)data andIcon:(UIImage*)icon {
    GMSMarker *marker = [[GMSMarker alloc] init];

    marker.position = CLLocationCoordinate2DMake([data.gpsLat floatValue], [data.gpsLon floatValue]);
    marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    marker.map = nil;
    marker.icon = icon;
    marker.userData = data;
    
    return marker;
}

// Displays custom marker icon info window with all the mermaid data
- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
     mapIconView *iconView = [[[NSBundle mainBundle] loadNibNamed:@"mapmarkericonview" owner:self options:nil] objectAtIndex:0];
    FloatData *data = (FloatData *) marker.userData;
    [iconView provideFloatData:data];
    iconView.layer.cornerRadius = 15;
    iconView.layer.opacity = 0.7;
    
    return iconView;
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"GoToOptions"]) {
        OptionsViewController *destination = segue.destinationViewController;
        destination.instruments = [[NSMutableArray alloc] initWithObjects:@"All", nil];
        [destination.instruments addObjectsFromArray:self.instrumentNames];
        if (self.curr) {
            destination.currentInstrument= [self.curr getName];
            destination.currentInstrumentLabel.text = [self.curr getName];
            destination.currentFloatNameIndex = self.currentFloatIndex;
        }
        else {
            destination.currentInstrument=@"All";
        }
        destination.currentMarkerNumberIndex = self.currentMarkerNumberIndex;
        destination.markerNumber = self.markerNumber;
        destination.markerNumberLabel.text = [NSString stringWithFormat:@"Past %d location(s)", self.markerNumber];
    }
}

- (IBAction) backToMap:(UIStoryboardSegue *)unwindSegue {
    OptionsViewController *source = unwindSegue.sourceViewController;
    self.curr = [instruments objectForKey:source.currentInstrument];
    self.currentFloatIndex = source.currentFloatNameIndex;
    self.markerNumber = source.markerNumber;
    self.currentMarkerNumberIndex = source.currentMarkerNumberIndex;
}


- (void) instrumentSetup:(Instrument*)instrument {
    //Turn on new markers and make new path
    GMSMutablePath *originalPath = [self.mutablePaths objectForKey:[instrument getName]];
    GMSMutablePath *mutablePathForPolyline = [GMSMutablePath path];
    int n = self.markerNumber;
    if (n > [[instrument getFloatData] count]) {
        n = (int) [[instrument getFloatData] count];
    }
    
    for (int i = 0; i < n; i++) {
        float opac = 1 - (i/(n+1.0));
        [self turnOnMarker:[self.markers objectForKey:[instrument getName]][i] withOpacity:opac];
        [mutablePathForPolyline addCoordinate:[originalPath coordinateAtIndex:i]];
    }
    
    // Make the polyline
    GMSPolyline* newPolyline = [GMSPolyline polylineWithPath:mutablePathForPolyline];
    newPolyline.strokeWidth = self.polylineStrokeWidth;
    
    //set the polyline to the right color
    int j = (int)[[instruments allKeys] indexOfObject:[instrument getName]];
    while (j >= self.colors.count) {
        j -= self.colors.count;
    }
    //to make sure there's no overflow
    newPolyline.strokeColor = [self.colors objectAtIndex:j];
    
    newPolyline.map = self.appMapView;
    [self.onPolylines addObject:newPolyline];
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:YES];
    
    //Add on markers to the map
    [self addOnMarkersToMap];
}

- (void) clearOnPolylines {
    while (self.onPolylines.count > 0) {
        GMSPolyline *polylineToRemove = [self.onPolylines lastObject];
        polylineToRemove.map = nil;
        [self.onPolylines removeObject:polylineToRemove];
    }
}

- (void) instrumentTakeDown:(Instrument*) old {
    //Turn off all old markers
    for (GMSMarker* marker in [self.markers objectForKey:[old getName]]) {
        [self turnOffMarker:marker];
    }
    [self clearOnPolylines];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
