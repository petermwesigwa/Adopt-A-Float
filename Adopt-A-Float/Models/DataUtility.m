//
//  DataUtility.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Modified by Peter Mwesigwa on 8/18/20
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


+ (NSMutableDictionary<NSString *, Instrument *> *)createInstruments {
    NSMutableDictionary<NSString *, Instrument *> *createdInstruments = [NSMutableDictionary new];
    NSArray *floatNames = [NSArray new];
    NSDictionary<NSString *, NSString*> *sourceUrls = [DataUtility getSourceURLs];
    
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
        
        
        // remove extra zeros from the name (eg from P0026 to P026)
        // Names should have 4 characters
        NSString* standardizedName = [DataUtility standardizeFloatName:name];
        
        
        // create instrument with data if request succeeded
        if ([float_data count] > 0) {
            Instrument *ins = [[Instrument alloc]
                             initWithName:standardizedName andfloatData:float_data];
            [createdInstruments setObject:ins forKey:standardizedName];
        }
    }
    return createdInstruments;
}

+ (NSString *) standardizeFloatName: (NSString *) floatName {
    if ([floatName length] == 4) {
        return floatName;
    }
    return [floatName stringByReplacingOccurrencesOfString:@"00" withString:@"0"];
}


// THis method takes in the url and filters the data
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

/*
Returns a URL that can be used to get all past observations reported by an instrument.
The parameter floatName is the name of the instrument. The uurl is construacted using a
format string format_URL (usually retrieved from the source.plist file as URL_ONE.
 
Quick warning that this method might be refined in the near future as the way that the names
 are stored int he database is not the same way that they are inserted into the URL in order to
 get the instrument data.
*/
+ (NSURL *) getURLFromName: (NSString *) floatName usingFormat:(NSString *)format_URL {
    // Change all float names starting with N to P for the url (eg from N001 to P001)
    floatName = [floatName stringByReplacingOccurrencesOfString:@"N" withString:@"P"];
    
    // some strings have too many zeros (eg P0029) so replace multiple zeros with just one.
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

// This method retrieves all the necessary urls for retrieving data from the server.
// Returns a dictionary containing formats urls for retrieving all the instrument data
// or data for a specific instrument
+ (NSDictionary <NSString *, NSString *> *)getSourceURLs {
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
    
    return (NSMutableArray<NSMutableArray<NSString *> *> *)
    [[[data reverseObjectEnumerator] allObjects ] mutableCopy];
}

// Splits the string with the given set and removes empty elements
// Code in this method is adapted from stack overflow
+ (NSMutableArray<NSString *> *)splitString:(NSString *)str withSet:(NSCharacterSet *)set {
    NSArray *split = [str componentsSeparatedByCharactersInSet:set];
    return [NSMutableArray arrayWithArray:[split filteredArrayUsingPredicate:
                                           [NSPredicate predicateWithFormat:@"SELF != ''"]]];
}

/*
 This method contacts the remote server and performs a GET request using the url provided.
 Server is expected to return a string of characters, which is returned by the method
 */
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
