//
//  MainViewController.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import "MainViewController.h"
#import "Instrument.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

extern NSMutableDictionary* instruments;

@interface MainViewController () {
    NSArray *_instrumentPickerData;
    NSMutableDictionary *markers;
    Instrument *curr;
    __weak IBOutlet UILabel *titleLabel;
    int defaultMarkerNumber;
    int markerNumber;
    NSMutableArray *onMarkers;
    NSArray *colors;
}

@end

@implementation MainViewController {
    GMSMapView *mapView_;
}
//@synthesize instrumentPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Make the pop-up picker view
    NSLog(@"Before making the picker view");
    draw1 = 0;
    _instrumentPickerData = [instruments allKeys];
    instrumentPicker.dataSource = self;
    instrumentPicker.delegate = self;
    NSLog(@"Picker view data, data source, and delegate are set");
    
    //Make colors array
    colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor blackColor], [UIColor grayColor], [UIColor whiteColor]];
    
    //round picker view edges
    instrumentPicker.layer.cornerRadius = 5;
    instrumentPicker.layer.masksToBounds = YES;
    //hide picker initially
    instrumentPicker.hidden = YES;
    
    // Create markers for all positions of all floats
    markers = [[NSMutableDictionary alloc] init];
    onMarkers = [[NSMutableArray alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    int j = 0;
    for(NSString*name in instrumentNames) {
        Instrument* instr = [instruments objectForKey:name];
        //set icon color
        //UIImage *icon = [UIImage imageNamed:@"instrument"]; < ****this works to change image
        if (j == colors.count) j = 0; //to make sure there's no overflow
        UIImage *icon = [GMSMarker markerImageWithColor:[colors objectAtIndex:j]];
        
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        for (int i = 0; i < instr.lon.count; i++) { //count of lon and lat should be the same
            GMSMarker* marker = [self createMarkerWithLat:instr.lat[i] andLong:instr.lon[i] andTitle:instr.name andSnippet:[NSString stringWithFormat:@"t-%d hours", i] andIcon:icon];
            [markersForInstr addObject:marker];
        }
        [markers setObject:markersForInstr forKey:name];
        j++;
    }
    
    // Show first 5 markers for default instrument
    defaultMarkerNumber = 5;
    markerNumber = defaultMarkerNumber;
    curr = [instruments allValues][0]; //Whichever instrument is the first in the array
    [self instrumentSetup];
    
    // Create a GMSCameraPosition for the initial camera
    NSLog(@"before setting the camera");
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
                                                            longitude:0.0
                                                                 zoom:1];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    appMapView.camera = camera;
    appMapView.mapType = kGMSTypeSatellite;
    NSLog(@"After setting the camera");
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:NO];
}

- (void) updateCameraPositionWithAnimation:(BOOL)animation {
    double lonMin = MAXFLOAT;
    double lonMax = -MAXFLOAT;
    double latMin = MAXFLOAT;
    double latMax = -MAXFLOAT;
    for (GMSMarker *marker in onMarkers) {
        NSLog(@"The comparison is happening");
        if (marker.position.longitude < lonMin)
            lonMin = marker.position.longitude;
        if (marker.position.longitude > lonMax)
            lonMax = marker.position.longitude;
        if (marker.position.latitude < latMin)
            latMin = marker.position.latitude;
        if (marker.position.latitude > latMax)
            latMax = marker.position.latitude;
    }
    NSLog(@"lonMin = %f", lonMin);
    NSLog(@"lonMax = %f", lonMax);
    NSLog(@"latMin = %f", latMin);
    NSLog(@"latMax = %f", latMax);
    //Potential bug in these coordinates, but don't know how to fix
     //Relating to which coord is more east and which is more west (wraparound)
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(latMax, lonMax);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(latMin, lonMin);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    if (animation == NO)
        [appMapView moveCamera:update];
    else [appMapView animateWithCameraUpdate:update];
}

- (GMSMarker*)createMarkerWithLat:(NSNumber*)lat andLong:(NSNumber*)lon andTitle:(NSString*)title andSnippet:(NSString*)snip andIcon:(UIImage*)icon {
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
        // If want instrument to change not when moving the picker but when
         // finished with it (touch button again), add that here
    }
}

- (IBAction)touchHistoryButton:(id)sender {
    if (!historyButton.isSelected) {
        [historyButton setSelected:YES];
        [self clearOnMarkers];
        markerNumber = (int)[curr.lat count];
        [self instrumentSetup];
    }
    else {
        [historyButton setSelected:NO];
        [self clearOnMarkers];
        markerNumber = defaultMarkerNumber;
        [self instrumentSetup];
    }
}

- (void) clearOnMarkers {
    while (onMarkers.count > 0)
        [self turnOffMarker:[onMarkers lastObject]];
}

- (IBAction)touchShowAllButton:(id)sender {
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Only have 1 picker view so don't need an if-else statement
    NSString *name = [self pickerView:pickerView titleForRow:row forComponent:0];
    [self instrumentTakeDown:curr];
    curr = [instruments objectForKey:name];
    [self instrumentSetup];
}

- (void) instrumentSetup {
    //Turn on new markers
    for (int i = 0; i < markerNumber; i++) {
        float opac = 1 - (i/(markerNumber+1.0));
        [self turnOnMarker:[markers objectForKey:curr.name][i] withOpacity:opac];
    }
    
    //Change label
    titleLabel.text = curr.name;
    NSLog(@"Current instrument is %@", curr.name);
    
    //Update the camera position
    [self updateCameraPositionWithAnimation:YES];
    
    //Add on markers to the map
    [self addOnMarkersToMap];
}

- (void) instrumentTakeDown:(Instrument*) old {
    //Turn off all old markers
    for (GMSMarker* marker in [markers objectForKey:old.name]) {
        [self turnOffMarker:marker];
    }
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
