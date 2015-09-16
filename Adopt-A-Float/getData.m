//
//  getData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getData.h"

@implementation getData

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
        [twoByTwo addObject:finalArr];
    }
    
    return twoByTwo;
}

@end
