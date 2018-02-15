//
//  MainViewController.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "MainViewController.h"
#import "Instrument.h"
#import "FloatDataRow.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

extern NSMutableDictionary* instruments;

@interface MainViewController () {
    NSArray *_instrumentPickerData;
    NSMutableDictionary *markers;
    NSMutableDictionary *mutablePaths;
    Instrument *curr;
    __weak IBOutlet UILabel *titleLabel;
    int defaultMarkerNumber;
    int markerNumber;
    NSMutableArray *onMarkers;
    NSMutableArray *onPolylines;
    NSArray *colors;
    int polylineStrokeWidth;
}

@end

@implementation MainViewController {
    GMSMapView *_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //to make status bar white
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Basic initializations
    polylineStrokeWidth = 3;
    
    //Make the pop-up picker view
    draw1 = 0;
    _instrumentPickerData = [instruments allKeys];
    instrumentPicker.dataSource = self;
    instrumentPicker.delegate = self;
    
    //Make colors array
    colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor blackColor], [UIColor grayColor], [UIColor whiteColor]];
    
    //round picker view edges
    instrumentPicker.layer.cornerRadius = 5;
    instrumentPicker.layer.masksToBounds = YES;
    //hide picker initially
    instrumentPicker.hidden = YES;
    
    // Create markers and paths for all positions of all floats
    markers = [[NSMutableDictionary alloc] init];
    mutablePaths = [[NSMutableDictionary alloc] init];
    onMarkers = [[NSMutableArray alloc] init];
    onPolylines = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString *name in instrumentNames) {

        //set icon color
        if (j == colors.count) j = 0; //to make sure there's no overflow
        UIImage *icon = [GMSMarker markerImageWithColor:[colors objectAtIndex:j]];
        
        // make an array of markers and a path for each object
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        GMSMutablePath *newPath = [GMSMutablePath path];
        int i = 0;
        Instrument* instr = [instruments objectForKey:name];
        for (FloatDataRow *row in instr.floatData) {
            
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
        [mutablePaths setObject:newPath forKey:name];
        [markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show first 5 markers for default instrument
    defaultMarkerNumber = 5;
    markerNumber = defaultMarkerNumber;
    curr = [instruments allValues][0];  // Whichever instrument is the first in the array
    [self instrumentSetup:curr];
    
    // Create a GMSCameraPosition for the initial camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0 longitude:0.0 zoom:1];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    appMapView.camera = camera;
    appMapView.mapType = kGMSTypeHybrid;
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:NO];
}

- (void) updateCameraPositionWithAnimation:(BOOL)animation {
    double lonMin = MAXFLOAT;
    double lonMax = -MAXFLOAT;
    double latMin = MAXFLOAT;
    double latMax = -MAXFLOAT;
    for (GMSMarker *marker in onMarkers) {
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
        [appMapView moveCamera:update];
    else [appMapView animateWithCameraUpdate:update];
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
    [onMarkers removeObject:marker];
}

- (void)turnOnMarker:(GMSMarker*) marker withOpacity:(float)opac {
    marker.opacity = opac;
    [onMarkers addObject:marker];
}

- (void) addOnMarkersToMap {
    for (GMSMarker* marker in onMarkers) {
        marker.map = appMapView;
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
    if (draw1 ==0) {
        draw1 = 1;
        [self.view bringSubviewToFront:instrumentPicker];
        instrumentPicker.hidden = NO;
    } else {
        draw1 = 0;
        instrumentPicker.hidden = YES;
    }
}

- (IBAction)touchHistoryButton:(id)sender {
    if (!historyButton.isSelected) {
        [historyButton setSelected:YES];
        [self clearOnMarkers];
        [self clearOnPolylines];
        markerNumber = (int)[curr.floatData count];
        if (!showAllButton.selected)
            [self instrumentSetup:curr];
        else {
            for (Instrument* ins in [instruments allValues]) {
                [self instrumentSetup:ins];
            }
        }
    }
    else {
        [historyButton setSelected:NO];
        [self clearOnMarkers];
        [self clearOnPolylines];
        markerNumber = defaultMarkerNumber;
        if (!showAllButton.selected)
            [self instrumentSetup:curr];
        else {
            for (Instrument* ins in [instruments allValues]) {
                [self instrumentSetup:ins];
            }
        }
    }
}

- (void) clearOnMarkers {
    while (onMarkers.count > 0)
        [self turnOffMarker:[onMarkers lastObject]];
}

- (IBAction)touchShowAllButton:(id)sender {
    if (!showAllButton.isSelected) {
        [showAllButton setSelected:YES];
        [self clearOnMarkers];
        [self clearOnPolylines];
        for (Instrument* ins in [instruments allValues]) {
            [self instrumentSetup:ins];
        }
    }
    else {
        [showAllButton setSelected:NO];
        [self clearOnMarkers];
        [self clearOnPolylines];
        [self instrumentSetup:curr];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Only have 1 picker view so don't need an if-else statement
    NSString *name = [self pickerView:pickerView titleForRow:row forComponent:0];
    if (!showAllButton.selected)
        [self instrumentTakeDown:curr];
    curr = [instruments objectForKey:name];
    if (!showAllButton.selected)
        [self instrumentSetup:curr];
}

- (void) instrumentSetup:(Instrument*)instrument {
    //Turn on new markers and make new path
    GMSMutablePath *originalPath = [mutablePaths objectForKey:instrument.name];
    GMSMutablePath *mutablePathForPolyline = [GMSMutablePath path];
    for (int i = 0; i < markerNumber; i++) {
        float opac = 1 - (i/(markerNumber+1.0));
        [self turnOnMarker:[markers objectForKey:instrument.name][i] withOpacity:opac];
        [mutablePathForPolyline addCoordinate:[originalPath coordinateAtIndex:i]];
    }
    
    // Make the polyline
    GMSPolyline* newPolyline = [GMSPolyline polylineWithPath:mutablePathForPolyline];
    newPolyline.strokeWidth = polylineStrokeWidth;
    
    //set the polyline to the right color
    int j = (int)[[instruments allKeys] indexOfObject:instrument.name];
    while (j >= colors.count) {
        j -= colors.count;
    }
    //to make sure there's no overflow
    newPolyline.strokeColor = [colors objectAtIndex:j];
    
    newPolyline.map = appMapView;
    [onPolylines addObject:newPolyline];
    
    //Change label
    if (showAllButton.selected) titleLabel.text = @"All";
    else titleLabel.text = curr.name;
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:YES];
    
    //Add on markers to the map
    [self addOnMarkersToMap];
}

- (void) clearOnPolylines {
    while (onPolylines.count > 0) {
        GMSPolyline *polylineToRemove = [onPolylines lastObject];
        polylineToRemove.map = nil;
        [onPolylines removeObject:polylineToRemove];
    }
}

- (void) instrumentTakeDown:(Instrument*) old {
    //Turn off all old markers
    for (GMSMarker* marker in [markers objectForKey:old.name]) {
        [self turnOffMarker:marker];
    }
    [self clearOnPolylines];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
