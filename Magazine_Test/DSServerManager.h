//
//  DSServerManager.h
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSAccessToken.h"
#import "DSProduct.h"
#import "DSReview.h"
#import "DSUser.h"

@interface DSServerManager : NSObject


+ (DSServerManager *)sharedManager;

- (void) getProductsOnSuccess:(void(^)(NSArray* products)) success
                             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) registerUser:(NSString*) username password:(NSString*) password
            onSuccess:(void(^)(DSUser* user)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getReviewForProduct:(NSString*) pr_id onSuccess:(void(^)(NSArray*  reviews)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) postReviewForProduct:(NSString*) pr_id text:(NSString*)text rate:(NSInteger) rate onSuccess:(void(^)(NSInteger reviewId)) success   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure ;

- (void) loginUser:(NSString*) username password:(NSString*) password onSuccess:(void(^)(id success)) success   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure ;

- (BOOL) userIsLogIn;

@end
