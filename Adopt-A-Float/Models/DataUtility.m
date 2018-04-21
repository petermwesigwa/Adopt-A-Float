//
//  DataUtility.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "DataUtility.h"

@interface DataUtility ()

@property (strong) NSDictionary *sources;

@end

@implementation DataUtility

NSString *const SOURCE_NAME = @"source";
NSString *const SOURCE_TYPE = @"plist";

+ (NSMutableDictionary<NSString *, Instrument *> *)createInstruments {
    NSMutableDictionary<NSString *, Instrument *> *result = [NSMutableDictionary new];
    NSDictionary *sourceUrls = [DataUtility getSourceURLs];
    for (NSString *name in sourceUrls) {
        // Create new instrument with name and array of FloatData objects
        Instrument *i = [[Instrument alloc] initWithName:name andfloatData:
                         [DataUtility getDataFromURL:
                          [NSURL URLWithString:[sourceUrls objectForKey:name]]]];
        [result setObject:i forKey:name];
    }
    return result;
}

// Return an array of FloatData objects retrieved from the url
+ (NSMutableArray<FloatData *> *)getDataFromURL:(NSURL *)url {
    NSString *response = [DataUtility downloadString:url];
    NSMutableArray *dataSet = [NSMutableArray new];
    // Create a FloatData object for each raw data row
    for (NSMutableArray *rawData in [DataUtility splitDataRows:response]) {
        if ([FloatData isValidRaw:rawData]) {
            [dataSet addObject:[[FloatData alloc] initWithRaw:rawData]];
        }
    }
    return dataSet;
}

// Load data source urls from `source.plist` with the form "{name:url, name:url, ...}"
+ (NSDictionary *)getSourceURLs {
    return [NSDictionary dictionaryWithContentsOfFile: 
        [[NSBundle mainBundle] pathForResource:SOURCE_NAME ofType:SOURCE_TYPE]];
}

// Splits data string by lines and then by whitespace. Returns an array of arrays,
// where each array contains the whitespace-delimited elements from its row.
+ (NSMutableArray<NSMutableArray<NSString *> *> *)splitDataRows:(NSString *)rawData {
    NSMutableArray<NSMutableArray<NSString *> *> *data = [NSMutableArray new];
    // split by lines and then whitespace
    NSMutableArray<NSString *> *lines = [DataUtility splitString:rawData withSet:
                                       [NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        NSMutableArray<NSString *> *values = [DataUtility splitString:line withSet:
                                              [NSCharacterSet whitespaceCharacterSet]];
        [data addObject:values];
    }
    
    return data;
}

// Splits the string with the given set and removes empty elements
+ (NSMutableArray<NSString *> *)splitString:(NSString *)str withSet:(NSCharacterSet *)set {
    //Method proposed on stack overflow, which works great
    NSArray *split = [str componentsSeparatedByCharactersInSet:set];
    return [NSMutableArray arrayWithArray:[split filteredArrayUsingPredicate:
                                           [NSPredicate predicateWithFormat:@"SELF != ''"]]];
}

// Returns the data as an NSString
+ (NSString *)downloadString:(NSURL *)url {
    // Fetch the JSON response
    __block NSString *result;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    // Clear cache (https://stackoverflow.com/a/24329317)
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // Make asynchronous request
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
        // Convert the data to a NSString
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Release sem lock to return the data
        dispatch_semaphore_signal(sem);
    }];
    
    // Wait for request to finish
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return result;
}

@end
