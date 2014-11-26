//
//  DSViewController.h
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
