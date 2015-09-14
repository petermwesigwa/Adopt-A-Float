//
//  HTTP.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/5/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import <Foundation/Foundation.h>

- (NSString *)stringWithUrl:(NSURL *)url {
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
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}