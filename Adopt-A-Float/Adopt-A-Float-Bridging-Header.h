// w
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "AppState.h"
#import "Instrument.h"

extern AppState *appStateManager;
extern NSMutableDictionary<NSString *, Instrument*> *instruments;
