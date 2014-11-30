//
//  DSAddReviewViewController.h
//  Magazine_Test
//
//  Created by Dima on 11/29/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DSAddReviewDelegete;

@interface DSAddReviewViewController : UIViewController

@property (strong,nonatomic) NSString* pr_id;
@property (weak,nonatomic) id <DSAddReviewDelegete> delegate;

@end


@protocol DSAddReviewDelegete <NSObject>

- (void)updateData;

@end

