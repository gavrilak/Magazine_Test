//
//  DSReviewCell.h
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSRateView.h"

@interface DSReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DSRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@end
