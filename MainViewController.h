//
//  MainViewController.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/20/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MainViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate> {
    
    __weak IBOutlet UIButton *showAllButton;
    __weak IBOutlet UIButton *historyButton;
    __weak IBOutlet GMSMapView *appMapView;
    __weak IBOutlet UIPickerView *instrumentPicker;
    __weak IBOutlet UIButton *instrumentButton;
    int draw1;
}
- (IBAction)touchInstrumentButton:(id)sender;


@end
