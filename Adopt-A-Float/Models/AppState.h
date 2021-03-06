//
//  AppState.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/30/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instrument.h"
#import <GoogleMaps/GoogleMaps.h>


NS_ASSUME_NONNULL_BEGIN

@interface AppState : NSObject
    // lost of all the instrument names
    @property (strong) NSArray<NSString *> *instrNames;

    // name of the currently selected instrument
    @property (strong) NSString *selectedInstr;

    // index to locate selected instrument within array
    @property (assign) int selectedInstrIndex;

    @property (strong) NSArray<NSNumber *> *mapViewTypes;

    @property (assign) int selectedMapViewIndex;
    


// this creates the initial state object
-(id) initWithInstruments:(NSMutableDictionary<NSString *, Instrument*> *)instruments;


@end

NS_ASSUME_NONNULL_END
