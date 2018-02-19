//
//  getData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getData.h"
#import "FloatDataRow.h"
#import "Instrument.h"

@interface getData ()

+ (NSMutableArray*)stringWithUrl:(NSURL *)url;
+ (NSMutableDictionary*) dataToInstrumentObject:(NSArray*) inputArray andInstruments:(NSMutableDictionary *)instruments;

@end

@implementation getData

+ (NSMutableDictionary*) getData:(NSMutableDictionary*) instruments {
    
    // Load real data from urls in `source.plist` with the form "{name:url, name:url, ...}"
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"source" ofType:@"plist"];
    NSDictionary *sourceContents = [NSDictionary dictionaryWithContentsOfFile: sourcePath];

    // Create a new instrument for each data source
    for (NSString *key in sourceContents) {
        NSArray *instrumentArray = [NSArray arrayWithObjects:key,
                                    [NSURL URLWithString:[sourceContents objectForKey:key]], nil];
        instruments = [self dataToInstrumentObject:instrumentArray andInstruments:instruments];
    }
    
    return instruments;
}

+ (NSMutableDictionary*) dataToInstrumentObject:(NSArray*)inputArray andInstruments:(NSMutableDictionary *)instruments {
    
    // Not going to store all data, just last 30 days
    NSString *name = inputArray[0];
    NSURL *url = inputArray[1];
    NSMutableArray *data = [self stringWithUrl:url];
    
    // Make objects for variables in each row, store in MutArray
    NSMutableArray *output = [[NSMutableArray alloc]init];
    for (id row in data) {
        FloatDataRow *valsAtTime = [[FloatDataRow alloc] initWithMutArr:row];
        [output addObject:valsAtTime];
    }
    
    // If no objects exist under name, create new object
    if(![instruments objectForKey:name]) {
        Instrument *newInstrument = [[Instrument alloc] initWithName:name andfloatData:output];
        [instruments setValue:newInstrument forKey:newInstrument.name];
    }

    return instruments;
}

// Returns an array of rows (arrays) with each value from the dataset
+ (NSMutableArray *)stringWithUrl:(NSURL *)url {
    
    // Fetch the JSON response
    __block NSMutableArray *twoByTwo = [[NSMutableArray alloc] init];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    // Make asynchronous request
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          
          // Construct a String around the Data from the response
          NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSMutableArray *indivLines = [[NSMutableArray alloc] initWithArray:[returnString componentsSeparatedByString:@"\n"]];
          
          // Remove last string of array, which is blank
          [indivLines removeObjectAtIndex:[indivLines count]-1];
          for (NSString* string in indivLines) {
              //Method proposed on stack overflow, which works great
              NSPredicate *nonEmptyValue = [NSPredicate predicateWithFormat:@"SELF != ''"];
              NSArray *parts = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
              NSArray *finalArr = [parts filteredArrayUsingPredicate:nonEmptyValue];
              NSMutableArray *finalMutArr = [NSMutableArray arrayWithArray:finalArr];
              [twoByTwo addObject:finalMutArr];
          }
          
          // Signal ready to return `twoByTwo`
          dispatch_semaphore_signal(sem);
          
      }] resume];
    
    // Wait for request to finish
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    return twoByTwo;
}

@end
