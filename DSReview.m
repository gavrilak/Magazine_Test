//
//  DSReview.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSReview.h"

@implementation DSReview

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.rw_id = [[responseObject objectForKey:@"id"]stringValue] ;
        self.product= [[responseObject objectForKey:@"product"]stringValue];
        self.user = [[responseObject objectForKey:@"created_by"]objectForKey:@"username"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"];
        self.date= [dateFormat dateFromString:[responseObject objectForKey:@"created_at"]];
        if (self.date == nil){
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
            self.date= [dateFormat dateFromString:[responseObject objectForKey:@"created_at"]];
        }
        self.rate = [[responseObject objectForKey:@"rate"] stringValue];
        self.text = [responseObject objectForKey:@"text"];
    }
    return self;
}



@end
