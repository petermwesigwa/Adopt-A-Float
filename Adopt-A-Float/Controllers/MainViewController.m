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


@implementation MainViewController


- (void) viewDidAppear:(BOOL)animated {

    //take down all visible instruments
    for (Instrument *ins in [instruments allValues]) {
        [self instrumentTakeDown:ins];
    }
    
    // if instrument is chosen set it up
    if (self.curr) {
        [self instrumentSetup:self.curr];
    }
    
    // otherwise display all the instruments
    else {
        for (Instrument *ins in [instruments allValues]) {
            [self instrumentSetup:ins];
        }
    }
    
    self.titleLabel.text = appStateManager.selectedInstr;
    self.appMapView.mapType = [[appStateManager.mapViewTypes objectAtIndex:
                                appStateManager.selectedMapViewIndex] intValue];
}

- (void) viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //to make status bar white
    [self setNeedsStatusBarAppearanceUpdate];
    self.infoPanel.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.infoPanel.layer.cornerRadius = 4;
    self.infoPanel.layer.opacity = 0.85;
    self.polylineStrokeWidth = 2;
    
    self.instrumentNames = [[instruments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.currentFloatIndex = 0;
    
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

        }
        [self.markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show most recent marker for instrument by default
    self.defaultMarkerNumber = 1;
    self.markerNumber = self.defaultMarkerNumber;
    
    
    // Create a GMSCameraPosition for the initial camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:10.0 longitude:0.0 zoom:1];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.appMapView.delegate = self;
    self.appMapView.camera = camera;
    self.appMapView.mapType = [[appStateManager.mapViewTypes objectAtIndex:
                               appStateManager.selectedMapViewIndex] intValue];
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:NO];
}

// moves google map camera to display the floats currently in focus
- (void) updateCameraPositionWithAnimation:(BOOL)animation {
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in _onMarkers) {
        if (![bounds isValid]) {
            bounds = [bounds initWithCoordinate:marker.position coordinate:marker.position];
        } else {
            bounds = [bounds includingCoordinate:marker.position];
        }
    }
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:15.0];
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

// Displays custom marker icon info window with all the mermaid data
- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
     mapIconView *iconView = [[[NSBundle mainBundle] loadNibNamed:@"mapmarkericonview" owner:self options:nil] objectAtIndex:0];
    FloatData *data = (FloatData *) marker.userData;
    [iconView provideFloatData:data];
    iconView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    iconView.layer.cornerRadius = 15;
    iconView.layer.opacity = 0.98;
    
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
        
    }
}

- (IBAction) backToMap:(UIStoryboardSegue *)unwindSegue {
    self.curr = [instruments objectForKey:appStateManager.selectedInstr];
    self.markerNumber = [[appStateManager.markerNumbers objectAtIndex:appStateManager.selectedMarkerNumIndex] intValue];
}

- (IBAction)backFromLegend:(UIStoryboardSegue *)unwindSegue {
    
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
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
