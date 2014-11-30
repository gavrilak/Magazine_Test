//
//  DSMainViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/26/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSMainViewController.h"
#import "DSServerManager.h"

@implementation DSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
    
    [self.loginTextField setAlpha:0];
    [self.passwordTextField setAlpha:0];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accessAccount:(id)sender
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [self.loginTextField setAlpha:1];
                         [self.passwordTextField setAlpha:1];
                     }
     ];
}

- (IBAction)login:(id)sender
{
    [sender resignFirstResponder];
    
    if (self.loginTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Login cannot be empty...", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else if (self.passwordTextField.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Password cannot be empty...", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else{
  
        [[DSServerManager sharedManager] loginUser:self.loginTextField.text password:self.passwordTextField.text onSuccess:^(id succsecc) {
            NSLog(@"Ok");
            
        } onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                        message:NSLocalizedString(@"Login failed.....", nil)
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }];
     
       
    }
}


@end
