//
//  DSAccessToken.m
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSAccessToken.h"

@implementation DSAccessToken

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.token = [responseObject objectForKey:@"access_token"];
        NSTimeInterval interval = [[responseObject objectForKey:@"expires_in"]doubleValue];
        self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    }
    return self;
}


@end
