//
//  DSAccessToken.h
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;


- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
