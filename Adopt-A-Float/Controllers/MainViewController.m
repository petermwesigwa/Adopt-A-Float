//
//  MainViewController.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "MainViewController.h"

extern NSMutableDictionary<NSString *, Instrument *> *instruments;

@interface MainViewController ()
    @property (strong) NSArray *instrumentPickerData;
    @property (strong) NSMutableDictionary *markers;
    @property (strong) NSMutableDictionary *mutablePaths;
    @property (strong) Instrument *curr;
    @property (weak) IBOutlet UILabel *titleLabel;
    @property (assign) int defaultMarkerNumber;
    @property (assign) int markerNumber;
    @property (strong) NSMutableArray *onMarkers;
    @property (strong) NSMutableArray *onPolylines;
    @property (strong) NSArray *colors;
    @property (assign) int polylineStrokeWidth;

    @property (weak) IBOutlet UIButton *showAllButton;
    @property (weak) IBOutlet UIButton *historyButton;
    @property (weak) IBOutlet GMSMapView *appMapView;
    @property (weak) IBOutlet UIPickerView *instrumentPicker;
    @property (weak) IBOutlet UIButton *instrumentButton;

    @property (assign) int draw1;

    @property (strong) GMSMapView *mapView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //to make status bar white
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Basic initializations
    self.polylineStrokeWidth = 3;
    
    //Make the pop-up picker view
    self.draw1 = 0;
    self.instrumentPickerData = [instruments allKeys];
    self.instrumentPicker.dataSource = self;
    self.instrumentPicker.delegate = self;
    
    //Make colors array
    self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor blackColor], [UIColor grayColor], [UIColor whiteColor], [UIColor darkGrayColor], [UIColor lightGrayColor]];
    
    //round picker view edges
    self.instrumentPicker.layer.cornerRadius = 5;
    self.instrumentPicker.layer.masksToBounds = YES;
    //hide picker initially
    self.instrumentPicker.hidden = YES;
    
    // Create markers and paths for all positions of all floats
    self.markers = [[NSMutableDictionary alloc] init];
    self.mutablePaths = [[NSMutableDictionary alloc] init];
    self.onMarkers = [[NSMutableArray alloc] init];
    self.onPolylines = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString *name in instrumentNames) {

        //set icon color
        if (j == self.colors.count) j = 0; //to make sure there's no overflow
        UIImage *icon = [GMSMarker markerImageWithColor:[self.colors objectAtIndex:j]];
        
        // make an array of markers and a path for each object
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        GMSMutablePath *newPath = [GMSMutablePath path];
        int i = 0;
        Instrument* instr = [instruments objectForKey:name];
        for (FloatData *row in instr.floatData) {
            
            //Create new marker and add to marker array
            GMSMarker* marker;
            bool gps = !([row.gpsLon floatValue] == 0); //if equal to 0, then NaN
            if (!gps) {
                marker = [self createMarkerWithLat:row.dopLat andLong:row.dopLon andTitle:name andSnippet:[NSString stringWithFormat:@"t-%d hours", i] andIcon:icon];
            }
            else {
                marker = [self createMarkerWithLat:row.gpsLat andLong:row.gpsLon andTitle:name andSnippet:[NSString stringWithFormat:@"t-%d hours", i] andIcon:icon];
            }
            [markersForInstr addObject:marker];
            
            //Add location to path
            if (gps) {
                [newPath addLatitude:[row.gpsLat doubleValue] longitude:[row.gpsLon doubleValue]];
            }
            else {
                [newPath addLatitude:[row.dopLat doubleValue] longitude:[row.dopLon doubleValue]];
            }
            i++;
        }
        [self.mutablePaths setObject:newPath forKey:name];
        [self.markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show first 5 markers for default instrument
    self.defaultMarkerNumber = 5;
    self.markerNumber = self.defaultMarkerNumber;
// TODO bug if no instrument
    self.curr = [instruments allValues][0];  // Whichever instrument is the first in the array
    [self instrumentSetup:self.curr];
    
    // Create a GMSCameraPosition for the initial camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0 longitude:0.0 zoom:1];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
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

- (GMSMarker*)createMarkerWithLat:(const NSNumber*)lat andLong:(const NSNumber*)lon andTitle:(NSString*)title andSnippet:(NSString*)snip andIcon:(UIImage*)icon {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
    marker.title = title;
    marker.snippet = snip;
    marker.map = nil;
    marker.icon = icon;
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

// The number of columns of data in picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _instrumentPickerData.count;
}

// The data to return for the row and component (column) that's being passed in to picker view
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _instrumentPickerData[row];
}

- (IBAction)touchInstrumentButton:(id)sender {
    if (self.draw1 ==0) {
        self.draw1 = 1;
        [self.view bringSubviewToFront:self.instrumentPicker];
        self.instrumentPicker.hidden = NO;
    } else {
        self.draw1 = 0;
        self.instrumentPicker.hidden = YES;
    }
}

- (IBAction)touchHistoryButton:(id)sender {
    if (!self.historyButton.isSelected) {
        [self.historyButton setSelected:YES];
        [self clearOnMarkers];
        [self clearOnPolylines];
        self.markerNumber = (int)[self.curr.floatData count];
        if (!self.showAllButton.selected)
            [self instrumentSetup:self.curr];
        else {
            for (Instrument* ins in [instruments allValues]) {
                [self instrumentSetup:ins];
            }
        }
    }
    else {
        [self.historyButton setSelected:NO];
        [self clearOnMarkers];
        [self clearOnPolylines];
        self.markerNumber = self.defaultMarkerNumber;
        if (!self.showAllButton.selected)
            [self instrumentSetup:self.curr];
        else {
            for (Instrument* ins in [instruments allValues]) {
                [self instrumentSetup:ins];
            }
        }
    }
}

- (void) clearOnMarkers {
    while (self.onMarkers.count > 0)
        [self turnOffMarker:[self.onMarkers lastObject]];
}

- (IBAction)touchShowAllButton:(id)sender {
    if (!self.showAllButton.isSelected) {
        [self.showAllButton setSelected:YES];
        [self clearOnMarkers];
        [self clearOnPolylines];
        for (Instrument* ins in [instruments allValues]) {
            [self instrumentSetup:ins];
        }
    }
    else {
        [self.showAllButton setSelected:NO];
        [self clearOnMarkers];
        [self clearOnPolylines];
        [self instrumentSetup:self.curr];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Only have 1 picker view so don't need an if-else statement
    NSString *name = [self pickerView:pickerView titleForRow:row forComponent:0];
    if (!self.showAllButton.selected)
        [self instrumentTakeDown:self.curr];
    self.curr = [instruments objectForKey:name];
    if (!self.showAllButton.selected)
        [self instrumentSetup:self.curr];
}

- (void) instrumentSetup:(Instrument*)instrument {
    //Turn on new markers and make new path
    GMSMutablePath *originalPath = [self.mutablePaths objectForKey:instrument.name];
    GMSMutablePath *mutablePathForPolyline = [GMSMutablePath path];
    for (int i = 0; i < self.markerNumber; i++) {
        float opac = 1 - (i/(self.markerNumber+1.0));
        [self turnOnMarker:[self.markers objectForKey:instrument.name][i] withOpacity:opac];
        [mutablePathForPolyline addCoordinate:[originalPath coordinateAtIndex:i]];
    }
    
    // Make the polyline
    GMSPolyline* newPolyline = [GMSPolyline polylineWithPath:mutablePathForPolyline];
    newPolyline.strokeWidth = self.polylineStrokeWidth;
    
    //set the polyline to the right color
    int j = (int)[[instruments allKeys] indexOfObject:instrument.name];
    while (j >= self.colors.count) {
        j -= self.colors.count;
    }
    //to make sure there's no overflow
    newPolyline.strokeColor = [self.colors objectAtIndex:j];
    
    newPolyline.map = self.appMapView;
    [self.onPolylines addObject:newPolyline];
    
    //Change label
    if (self.showAllButton.selected) self.titleLabel.text = @"All";
    else self.titleLabel.text = self.curr.name;
    
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
    for (GMSMarker* marker in [self.markers objectForKey:old.name]) {
        [self turnOffMarker:marker];
    }
    [self clearOnPolylines];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
