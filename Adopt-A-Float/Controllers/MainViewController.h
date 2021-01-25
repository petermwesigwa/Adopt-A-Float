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


@interface MainViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>
    // THis is a dictionarny
    @property (strong) NSMutableDictionary *markers;
    @property (strong) NSMutableDictionary *mutablePaths;

    // Stores a reference to the current instrument whose
    @property (strong) Instrument *curr;
    @property (weak, nonatomic) IBOutlet UIButton *titleButton;
    @property (weak, nonatomic) IBOutlet UIButton *optionsButton;
    @property (weak) IBOutlet UIView *infoPanel;
    @property (weak, nonatomic) IBOutlet UIButton *legendButton;
    @property (weak, nonatomic) IBOutlet UIButton *zoomToUserButton;
    @property (weak, nonatomic) IBOutlet UIButton *nextFloatButton;
    @property (weak, nonatomic) IBOutlet UIButton *prevFloatButton;


    @property (weak, nonatomic) IBOutlet UIButton *zoomToMarkersButton;
    @property (assign) int defaultMarkerNumber;
    @property (assign) int markerNumber;
    @property (strong) NSMutableArray<GMSMarker *> *onMarkers;
    @property (strong) NSArray *colors;
    @property (assign) int polylineStrokeWidth;
    @property (strong) NSArray<NSString *> *instrumentNames;
    @property (weak) IBOutlet GMSMapView *appMapView;
    @property (assign) int currentFloatIndex;
    @property (assign) int currentMarkerNumberIndex;
    @property (strong) GMSMapView *mapView;
    @property (strong) CLLocationManager *locationManager;
@end
