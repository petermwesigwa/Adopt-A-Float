//
//  FloatData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "FloatData.h"

@interface FloatData ()

@property (strong) NSCalendar *cal;

@end

// degree to radian conversion
float const HAVERSINE_RADS_PER_DEGREE = M_PI / 180.0;

// radius of the earth in km
float const HAVERSINE_KM_RADIUS = 6371.0;


// number of columns of observation that each float records
// for now this number is 10 but Frederik might change it in the future
int const N_DATA_ELEMS = 10;

/* time that a float is expected to spend underwater between surfacings.
 Can be safely assumed that any consecutive points within this time of each
 other are within the same surfacing, and so are any other points close to them
 
 This is used to filter between surface drift and subsurface drift (as they occur at different speeds)
 
 Setting it to ZERO measures drift without classification as surface or subsurface drift
 
 Note that this number might change depending on the way the data is collected by Frederik et al.
 */
double const MIN_TIME_BETWEEN_SURFACINGS = 0.0;



NSString *rawDataOne = @"Obs1 21-Dec-2020 18:34:06 0 135.0 0.700 1.220 14560 12407 78574 375 20 7 2 2";
NSString *rawDataTwo = @"Obs2 21-Dec-2020 18:23:55 0 -135.0 1.220 14560 12407 78574 375 20 7 2 2";
NSString *rawDataThree = @"Obs3 13-Dec-2020 15:27:59 0 0 0.700 1.220 14560 12407 78574 375 20 7 2 2";
NSString *rawDataFour = @"obs4 13-Dec-2020 15:17:46 1.457550 -147.210900 0.700 1.220 14560 12407 78574 375 20 7 2 2";


@implementation FloatData

- (id)initWithRaw:(NSArray<NSString *> *)orderedData {
    self = [super init];
    if (self && [FloatData isValidRaw:orderedData]) {
        //set calendar
        _cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // read in the name of the instrument
        _deviceName = [FloatData standardizeFloatName:orderedData[0]];
        
        // get the date at which the observation was made
        NSMutableString *dateString = [[NSMutableString alloc]initWithString:orderedData[1]];
        [dateString appendString:@" "];
        [dateString appendString:orderedData[2]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
    
        //
        _gpsDate = [formatter dateFromString:dateString];
        _gpsLat = [NSNumber numberWithFloat:[orderedData[3] floatValue]];
        _gpsLon = [NSNumber numberWithFloat:[orderedData[4] floatValue]];
        _hdop = [NSNumber numberWithFloat:[orderedData[5] floatValue]];
        _vdop = [NSNumber numberWithFloat:[orderedData[6] floatValue]];
        _vbat = [NSNumber numberWithFloat:[orderedData[7] floatValue]];
        // ignore column 8 as minimum voltage
        _pInt = [NSNumber numberWithFloat:[orderedData[9] floatValue]];
        _pExt = [NSNumber numberWithFloat:[orderedData[10] floatValue]];
        _legLength = 0;
        _legTime = 0;
        _legSpeed = 0;
        _totalDistance = 0;
        _avgSpeed = 0;
        _totalTime = 0;
        _netDisplacement = 0;
    }
    [self updateWithGebcoDepth];
    return self;
}

+ (BOOL)isValidRaw:(NSArray<NSString *> *)raw {
    if (raw.count < N_DATA_ELEMS) {
        return NO;
    }
    for (NSString *entry in raw){
        if ([[entry uppercaseString] isEqualToString:@"NAN"]) {
            return NO;
        }
    }
    return YES;
}
- (void) updateLegDataUsingPreviousFloat:(FloatData *)prevFloat andFirstFloat: (FloatData *) firstFloat{
    double legTime = [self durationBetween:prevFloat];
    double legLength = [self distanceFrom:prevFloat];
    
    if (legTime > MIN_TIME_BETWEEN_SURFACINGS) {
        _legLength = legLength;
        _legTime = legTime;
        _legSpeed = legLength / legTime;
        _totalDistance = legLength + prevFloat.totalDistance;
        _totalTime = legTime + prevFloat.totalTime;
        _avgSpeed = _totalDistance / _totalTime;
        _netDisplacement = [self distanceFrom:firstFloat];
    } else {
        _legLength = prevFloat.legLength;
        _legTime = prevFloat.legTime;
        _legSpeed = prevFloat.legSpeed;
        _totalDistance = prevFloat.totalDistance;
        _totalTime = prevFloat.totalTime;
        _avgSpeed = prevFloat.avgSpeed;
        _netDisplacement = [self distanceFrom:firstFloat];
    }
    
}

// compute haversine distance between floats
- (double) distanceFrom:(FloatData *)that {
    double lat1 = [_gpsLat doubleValue] * HAVERSINE_RADS_PER_DEGREE;
    double lon1 = [_gpsLon doubleValue] * HAVERSINE_RADS_PER_DEGREE;
    double lat2 = [that.gpsLat doubleValue] * HAVERSINE_RADS_PER_DEGREE;
    double lon2 = [that.gpsLon doubleValue] * HAVERSINE_RADS_PER_DEGREE;
    double havDLat = 0.5 - 0.5 * cos(lat2 - lat1);
    double havDLon = 0.5 - 0.5 * cos(lon2 - lon1);
    double haversine = havDLat + cos(lat1) * cos(lat2) * havDLon;
    double centralAngle = 2 * atan2(sqrt(haversine), sqrt(1-haversine));
    return centralAngle * HAVERSINE_KM_RADIUS;
}
- (double) durationBetween:(FloatData *)that {
    double time1 = (double) [_gpsDate timeIntervalSince1970];
    double time2 = (double) [that.gpsDate timeIntervalSince1970];
    return fabs(time1 - time2) / 3600.0;
}

- (void) updateWithGebcoDepth {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
   
    double bb = 1.0 / 60.0;
    double lap = [_gpsLat doubleValue] - bb;
    double lop = [_gpsLon doubleValue] - bb;
    double lam = [_gpsLat doubleValue] + bb;
    double lom = [_gpsLon doubleValue] + bb;
    
    int pxw = 5, pxh = 5, pxx = 2, pxy = 2;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.gebco.net/data_and_products/gebco_web_services/web_map_service/mapserv?request=getfeatureinfo&service=wms&crs=EPSG:4326&layers=gebco_latest_2&query_layers=gebco_latest_2&BBOX=%f,%f,%f,%         f&info_format=text/plain&service=wms&x=%d&y=%d&width=%d&height=%d&version=1.3.0",lap,lop,lam,lom,pxx,pxy,pxw,pxh];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (error == nil) {
            NSArray<NSString *> *fields = [result componentsSeparatedByString:@"\'"];
            if (fields.count > 7) {
                self.gebcoDepth = [fields[7] doubleValue];
            }
        }
    }] resume];
    
    
}

+ (NSString *) standardizeFloatName:(NSString *)floatName {
    if ([floatName length] == 4) {
        return floatName;
    }
    return [floatName stringByReplacingOccurrencesOfString:@"00" withString:@"0"];
}

+ (void) runTests {
    FloatData *floatOne = [[FloatData alloc] initWithRaw: [[rawDataOne componentsSeparatedByString:@" "] mutableCopy]];
    FloatData *floatTwo = [[FloatData alloc] initWithRaw: [[rawDataTwo componentsSeparatedByString:@" "] mutableCopy]];
    FloatData *floatThree = [[FloatData alloc] initWithRaw: [[rawDataThree componentsSeparatedByString:@" "] mutableCopy]];
    FloatData *floatFour = [[FloatData alloc] initWithRaw: [[rawDataFour componentsSeparatedByString:@" "] mutableCopy]];
    double distOneTwo = 111.2;
    
    [floatThree updateLegDataUsingPreviousFloat:floatFour andFirstFloat:floatFour];
    [floatTwo updateLegDataUsingPreviousFloat:floatThree andFirstFloat:floatFour];
    [floatOne updateLegDataUsingPreviousFloat:floatTwo andFirstFloat:floatFour];
    
    // haversine function tests
    NSAssert([floatOne distanceFrom: floatOne] == 0, @"dist from float to itself is zero");
    NSAssert(fabs([floatOne distanceFrom:floatTwo] - distOneTwo) < 0.001, @"float1 distance to float2 is wrong");
    NSAssert(floatOne.legLength == floatTwo.legLength, @"Float1 and Float2 don't match (are you not filtering for surface drift)");
    NSAssert(floatThree.legLength == floatFour.legLength, @"Float3 and float4 don't match (are you not filtering for surface drift)");
    NSAssert(fabs(floatOne.legLength - distOneTwo) < 0.001, @"wrong length Float2 to float1");
}
@end
