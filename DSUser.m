//
//  DSUser.m
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSUser.h"

@implementation DSUser

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.userId = [responseObject objectForKey:@"id"];
        self.clientSecret = [responseObject objectForKey:@"client_secret"];
        self.clientKey = [responseObject objectForKey:@"client_key"];
        
    }
    return self;
}


@end
