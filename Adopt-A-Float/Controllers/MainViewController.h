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

@interface MainViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)touchInstrumentButton:(id)sender;

@end
