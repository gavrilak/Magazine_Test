//
//  DSReview.h
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSReview : NSObject

@property (strong,nonatomic) NSString *rw_id;
@property (strong,nonatomic) NSString *product;
@property (strong,nonatomic) NSString *user;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString *rate;
@property (strong,nonatomic) NSString *text;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

- (CGFloat) heightForText:(NSString*) text;

@end
