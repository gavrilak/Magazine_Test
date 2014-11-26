//
//  DSProduct.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSProduct.h"

@implementation DSProduct

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.pr_id = [[responseObject objectForKey:@"id"]stringValue] ;
        self.img = [responseObject objectForKey:@"img"];
        self.text = [responseObject objectForKey:@"text"];
        self.title = [responseObject objectForKey:@"title"];
    }
    return self;
}

    
@end
