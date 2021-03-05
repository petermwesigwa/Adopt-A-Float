//
//  mapIconView.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 7/29/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

// Implementation ofm mapiconView.h
#import "mapIconView.h"


@implementation mapIconView

- (void)provideFloatData:(DataPoint *)data {
    double gebcoDepth = [mapIconView fetchGebcoDepth:data];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy HH:mm:ss"];
    
    self.deviceName.text = (NSString*) data.deviceName;
    self.gpsDate.text = [NSString stringWithFormat:@"%@ GMT",[formatter stringFromDate:(NSDate*)data.gpsDate]];
    self.gpsLat.text = [NSString stringWithFormat:@"%11.6f", data.gpsLat];
    self.gpsLon.text = [NSString stringWithFormat:@"%11.6f", data.gpsLon];
    self.hdop.text = [NSString stringWithFormat:@"%.1f", data.hDop];
    self.vdop.text = [NSString stringWithFormat:@"%.1f", data.vDop];
    self.vBat.text =[NSString stringWithFormat:@"%.0f mV", data.vBat];
    self.pInt.text = [NSString stringWithFormat:@"%.0f Pa", data.intPressure];
    self.pExt.text = [NSString stringWithFormat:@"%.0f mbar", data.extPressure];
    self.legLength.text = [NSString stringWithFormat:@"%.3f km",data.legLength];
    self.legTime.text = [NSString stringWithFormat:@"%.3f h",data.legTime];
    self.legSpeed.text = [NSString stringWithFormat:@"%.3f km/h",data.legSpeed];
    self.totalDist.text = [NSString stringWithFormat:@"%.3f km",data.totalDistance];
    self.totalTime.text = [NSString stringWithFormat:@"%.3f h",data.totalTime];
    self.avgSpeed.text = [NSString stringWithFormat:@"%.3f km/h",data.avgSpeed];
    self.WMSDepth.text = [NSString stringWithFormat:@"%.1f m", gebcoDepth];

}

+ (double) fetchGebcoDepth:(DataPoint *)dataPoint {
    // request object to query GEBCO server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    __block double gebcoDepth;
    
    /*
        Gebco stores the depths of the ocean as a grid over x and y values
        To find the depth for our datapoint we have to create a box around
     the point Essentially we have to create a square around the point within which to
        find a depth
     */
    
    double boxRadius = 1.0/60.0/2.00; // weird syntax but this is what works
    double bottom = dataPoint.gpsLat - boxRadius;
    double left = dataPoint.gpsLon - boxRadius;
    double top = dataPoint.gpsLat + boxRadius;
    double right = dataPoint.gpsLon + boxRadius;
    
    // more vars for creating the box. Again determined through experimentation
    int pxw = 5, pxh = 5, pxx = 2, pxy = 2;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.gebco.net/data_and_products/gebco_web_services/web_map_service/mapserv?request=getfeatureinfo&service=wms&crs=EPSG:4326&layers=gebco_latest_2&query_layers=gebco_latest_2&BBOX=%f,%f,%f,%         f&info_format=text/plain&service=wms&x=%d&y=%d&width=%d&height=%d&version=1.3.0",bottom,left,top,right,pxx,pxy,pxw,pxh];
    NSURL *url = [NSURL URLWithString:urlString];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (error == nil) {
            NSArray<NSString *> *fields = [result componentsSeparatedByString:@"\'"];
            if (fields.count > 7) {
                gebcoDepth = [fields[7] doubleValue];
            }
        }
    }] resume];
    
    return gebcoDepth;

}

+ (NSString *) prettyPrintDegree:(float)deg whichIsLat:(BOOL)isLat {
    NSString *format;
    
    if (isLat && deg > 0) {
        format = @"%.6f \u00B0N";
    } else if (isLat) {
        format = @"%.6f \u00B0S";
    } else if (deg > 0) {
        format = @"%.6f \u00B0E";
    } else {
        format = @"%.6f \u00B0W";
    }
    return [NSString stringWithFormat:format, fabsf(deg)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
