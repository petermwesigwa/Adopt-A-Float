//
//  getData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
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
    // Load real data from urls
    NSURL *robin30URL = [NSURL URLWithString:@"http://geoweb.princeton.edu/people/simons/SOM/ROBIN_030.txt"];
    NSArray *robinArray = [NSArray arrayWithObjects:@"robin",robin30URL, nil];
    
    NSURL *raffa30URL = [NSURL URLWithString:@"http://geoweb.princeton.edu/people/simons/SOM/RAFFA_030.txt"];
    NSArray *raffaArray = [NSArray arrayWithObjects:@"raffa",raffa30URL, nil];
    
    NSArray *urls = [NSArray arrayWithObjects:
                     robinArray,
                     raffaArray,
                     nil];
    for (id array in urls)
        instruments = [self dataToInstrumentObject:array andInstruments:instruments];
    return instruments;
}

+ (NSMutableDictionary*) dataToInstrumentObject:(NSArray*) inputArray andInstruments:(NSMutableDictionary *)instruments {
    
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
        NSLog(@"Doesn't contain %@", name);
        Instrument *newInstrument = [[Instrument alloc] initWithName:name andfloatData:output];
        [instruments setValue:newInstrument forKey:newInstrument.name];
        NSLog(@"Now contains %@", newInstrument.name);
    }
    
    return instruments;
}


+ (NSMutableArray *)stringWithUrl:(NSURL *)url {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSMutableArray *indivLines = [[NSMutableArray alloc] initWithArray:[returnString componentsSeparatedByString:@"\n"]];

    // Remove last string of array, which is blank
    [indivLines removeObjectAtIndex:[indivLines count]-1];
    NSMutableArray *twoByTwo = [[NSMutableArray alloc] init];
    for (NSString* string in indivLines) {
        
        //Method proposed on stack overflow, which works great
        NSPredicate *nonEmptyValue = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *finalArr = [parts filteredArrayUsingPredicate:nonEmptyValue];
        NSMutableArray *finalMutArr = [NSMutableArray arrayWithArray:finalArr];
        [twoByTwo addObject:finalMutArr];
    }
    // Convert all to NSNumbers
    /*for (NSMutableArray *line in twoByTwo) {
        for (int i = 0; i < [line count]; i++) {
            if (i <= 6 | ) {
                line[i] = [NSNumber numberWithInt:(int)line[i]];
            }
            else if ((7 <= i && i <= 15) ) {
                line[i] = [NSNumber numberWithFloat:line[i]];
            }
            
                
        }
    }*/
        
    
    
    return twoByTwo;
}

@end
