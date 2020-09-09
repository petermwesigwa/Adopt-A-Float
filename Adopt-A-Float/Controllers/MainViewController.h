//
//  MainViewController.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "Instrument.h"
#import "FloatData.h"
#import "AppState.h"
#import "mapIconView.h"


@interface MainViewController : UIViewController<UIPickerViewDelegate, GMSMapViewDelegate>
    // THis is a dictionarny
    @property (strong) NSMutableDictionary *markers;
    @property (strong) NSMutableDictionary *mutablePaths;

    // Stores a reference to the current instrument whose
    @property (strong) Instrument *curr;
    @property (weak) IBOutlet UILabel *titleLabel;
    @property (assign) int defaultMarkerNumber;
    @property (assign) int markerNumber;
    @property (strong) NSMutableArray *onMarkers;
    @property (strong) NSMutableArray *onPolylines;
    @property (strong) NSArray *colors;
    @property (assign) int polylineStrokeWidth;
    @property (strong) NSArray<NSString *> *instrumentNames;
    @property (weak) IBOutlet GMSMapView *appMapView;
    @property (assign) int currentFloatIndex;
    @property (assign) int currentMarkerNumberIndex;
    @property (strong) GMSMapView *mapView;
@end
