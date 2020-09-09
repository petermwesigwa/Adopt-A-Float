//
//  AppState.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/30/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import "AppState.h"

@implementation AppState
 
-(id)initWithInstruments:(NSMutableDictionary<NSString *, Instrument*> *)instruments {
    self = [super init];
    if (self) {
        _instrNames = [[NSMutableArray alloc] initWithObjects:@"All", nil];
        [_instrNames addObjectsFromArray:[instruments allKeys]];
        _markerNumbers = @[@1, @5, @10, @20, @INT_MAX];;
        _selectedInstr = @"All";
        _selectedInstrIndex = -1;
        _selectedMarkerNumIndex = 0;
    }
    return self;
}
@end
