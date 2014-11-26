//
//  DSUser.h
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSUser : NSObject

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* clientSecret;
@property (strong, nonatomic) NSString* clientKey;
@property (strong, nonatomic) NSString* userId;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
