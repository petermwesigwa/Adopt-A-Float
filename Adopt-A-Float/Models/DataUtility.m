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

// these urls are stored in source.plist
NSString *const URL_ALL = @"URL_ALL"; // retrieves the url for all the instruments
NSString *const URL_ONE = @"URL_ONE"; // retrieves url for the data for one instrument


/***************************************
 Create instruments and retrieves their data
 Returns a dictionary with keys of instrument names and values of instrument objects
 ***********************************/
+ (NSMutableDictionary<NSString *, Instrument *> *)createInstruments {
    NSMutableDictionary<NSString *, Instrument *> *result = [NSMutableDictionary new];
    NSArray *floatNames = [NSArray new];
    NSDictionary *sourceUrls = [DataUtility getSourceURLs];
    
    // read in the names of all the floats
    floatNames = [DataUtility getFloatNames:
                  [NSURL URLWithString:[sourceUrls objectForKey:URL_ALL]]];
    
    // obtain the data for all the instruments
    for (NSString *name in floatNames) {
        // url for this specific instrument
        NSURL *data_url = [DataUtility getURLFromName:name
                                          usingFormat:[sourceUrls objectForKey:URL_ONE]];
        
        // make a request to the url
        NSMutableArray<FloatData *> *float_data = [DataUtility getDataFromURL:data_url];
        
        // create instrument with data if request succeeded
        if ([float_data count] > 0) {
            Instrument *i = [[Instrument alloc]
                             initWithName:name andfloatData:float_data];
            [result setObject:i forKey:name];
        }
    }
    return result;
}

// return an array of the float names obtained from URL_ALL
+ (NSMutableArray<NSString *> *) getFloatNames: (NSURL *) url {
    NSMutableArray *floatNames = [NSMutableArray new];
    
    // retrieve information from server
    NSString *response = [DataUtility downloadString:url];
    
    // split by lines and then extract the first word of each line
    NSMutableArray<NSString *> *lines = [DataUtility splitString:response withSet:
                                         [NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        NSMutableArray<NSString *> *values = [DataUtility splitString:line withSet:
                                              [NSCharacterSet whitespaceCharacterSet]];
        [floatNames addObject:[values objectAtIndex:0]];
    }
    
    return floatNames;
}

// deduce the url for retrieving the instrument's data from it's name
+ (NSURL *) getURLFromName: (NSString *) floatName usingFormat:(NSString *)format_URL {
    // Change all float names starting with N to P for the url (eg from N001 to P001)
    floatName = [floatName stringByReplacingOccurrencesOfString:@"N" withString:@"P"];
    if ([floatName length] > 4) {
        floatName = [floatName stringByReplacingOccurrencesOfString:@"00" withString:@"0"];
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:
                                 format_URL, floatName]];
}

// Return an array of FloatData objects retrieved from the url
+ (NSMutableArray<FloatData *> *)getDataFromURL:(NSURL *)url {
    NSMutableArray *dataSet = [NSMutableArray new];
    // retrieve response from server
    NSString *response = [DataUtility downloadString:url];
    
    // return empty dataset if resource not found
    if ([response containsString:@"404 Not Found"]) {
        return dataSet;
    }
    
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
    
    return (NSMutableArray<NSMutableArray<NSString *> *> *)[[[data reverseObjectEnumerator] allObjects ] mutableCopy];
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
