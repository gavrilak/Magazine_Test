//
//  DSProduct.h
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSProduct : NSObject

@property (strong,nonatomic) NSString *pr_id;
@property (strong,nonatomic) NSString *img;
@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end
