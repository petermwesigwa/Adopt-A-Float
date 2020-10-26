//
//  AppState.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/30/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instrument.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppState : NSObject
    // Options available are the past 1, 5, 10 and 20 locations
    @property (strong) NSArray<NSNumber *> *markerNumbers;

    // keep track of currently selected option
    @property (assign) int selectedMarkerNumIndex;

    // lost of all the instrument names
    @property (strong) NSMutableArray<NSString *> *instrNames;

    // name of the currently selected instrument
    @property (strong) NSString *selectedInstr;

    // index to locate selected instrument within array
    @property (assign) int selectedInstrIndex;


// this creates the initial state object
-(id) initWithInstruments:(NSMutableDictionary<NSString *, Instrument*> *)instruments;


@end

NS_ASSUME_NONNULL_END
