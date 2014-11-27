//
//  DSMainViewController.h
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSMainViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
