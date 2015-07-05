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

extern NSMutableDictionary* instruments;

@interface MainViewController () {
    NSArray *_instrumentPickerData;
    NSMutableDictionary *markers;
    Instrument *curr;
    __weak IBOutlet UILabel *titleLabel;
    int defaultMarkerNumber;
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
    
    //round picker view edges
    instrumentPicker.layer.cornerRadius = 5;
    instrumentPicker.layer.masksToBounds = YES;
    //hide picker initially
    instrumentPicker.hidden = YES;
    
    // Create markers for all positions of all floats
    markers = [[NSMutableDictionary alloc] init];
    NSArray* instrumentNames = [instruments allKeys];
    for(NSString*name in instrumentNames) {
        Instrument* instr = [instruments objectForKey:name];
        NSMutableArray* markersForInstr = [[NSMutableArray alloc] init];
        for (int i = 0; i < instr.lon.count; i++) { //count of lon and lat should be the same
            GMSMarker* marker = [self createMarkerWithLat:instr.lat[i] andLong:instr.lon[i] andTitle:instr.name andSnippet:[NSString stringWithFormat:@"t-%d hours", i]];
            [markersForInstr addObject:marker];
        }
        [markers setObject:markersForInstr forKey:name];
    }
    
    // Show first 5 markers for default instrument
    defaultMarkerNumber = 5;
    curr = [instruments allValues][0]; //Whichever instrument is the first in the array
    [self instrumentSetup];
    
    // Create a GMSCameraPosition for the default instrument
    Instrument* camIns;
    NSLog(@"before getting raffa instrument");
    camIns = [instruments objectForKey:@"raffa"];
    float camLat = [camIns.lat[0] floatValue];
    float camLon = [camIns.lon[0] floatValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:camLat
                                                            longitude:camLon
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    appMapView.camera = camera;
    NSLog(@"After getting raffa instrument");
}

- (GMSMarker*)createMarkerWithLat:(NSNumber*)lat andLong:(NSNumber*)lon andTitle:(NSString*)title andSnippet:(NSString*)snip {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
    marker.title = title;
    marker.snippet = snip;
    marker.map = nil;
    return marker;
}

- (void)turnOffMarker:(GMSMarker*) marker {
    marker.map = nil;
}

- (void)turnOnMarker:(GMSMarker*) marker withOpacity:(float)opac {
    marker.map = appMapView;
    marker.opacity = opac;
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

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Only have 1 picker view so don't need an if-else statement
    NSString *name = [self pickerView:pickerView titleForRow:row forComponent:0];
    [self instrumentTakeDown:curr];
    curr = [instruments objectForKey:name];
    [self instrumentSetup];
}

- (void) instrumentSetup {
    //Turn on new markers
    for (int i = 0; i < defaultMarkerNumber; i++) {
        float opac = 1 - (i/(defaultMarkerNumber+1.0));
        [self turnOnMarker:[markers objectForKey:curr.name][i] withOpacity:opac];
    }
    //Change label
    titleLabel.text = curr.name;
    NSLog(@"Current instrument is %@", curr.name);
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
