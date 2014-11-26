//
//  DSServerManager.h
//  Weather_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSServerManager : NSObject


+ (DSServerManager *)sharedManager;

- (void) getProductsOnSuccess:(void(^)(NSArray* products)) success
                             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getReviewForProduct:(NSString*) pr_id onSuccess:(void(^)(NSArray*  reviews)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
@end
