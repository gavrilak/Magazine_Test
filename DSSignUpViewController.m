//
//  DSSignUpViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/27/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSSignUpViewController.h"
#import "DSProductViewController.h"
#import "DSServerManager.h"
#import "DSTextField.h"

#define KEYBOARD_OFFSET 10.0

@interface DSSignUpViewController ()


@property (weak, nonatomic) IBOutlet DSTextField *loginTextField;
@property (weak, nonatomic) IBOutlet DSTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet DSTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordConfirmationLabel;
@property (assign,nonatomic) CGRect keyboardBounds;

@end

@implementation DSSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    
    NSLog(@"Frame origin Y %f", self.view.frame.origin.y);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Actions

- (IBAction)submit:(id)sender
{
   if(self.loginTextField.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Login cannot be empty...", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else if(self.passwordTextField.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Password cannot be empty...", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else if(self.confirmPasswordTextField.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Confirm your password...", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else{
        
        if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
       
            [[DSServerManager sharedManager] registerUser: self.loginTextField.text password: self.passwordTextField.text onSuccess:^(DSUser *user) {
           
                  [self performSegueWithIdentifier:@"ShowShop" sender:self];
           
            } onFailure:^(NSError *error, NSInteger statusCode) {
               NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
        }];
        
        }
    }
}

- (IBAction)confirmPasswordChanged:(id)sender
{
    UITextField *textfield = (UITextField *)sender;
    
    [self.passwordConfirmationLabel setHidden:[self.passwordTextField.text isEqualToString:textfield.text]];
}


#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark keyboard notifications

- (void)keyboardWillShow: (NSNotification *)notification {
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = self.view.frame;
    rect.size.height -= self.keyboardBounds.size.height;
    self.view.frame = rect;

    [UIView commitAnimations];
}


- (void)keyboardWillHide: (NSNotification *)notification {
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = self.view.frame;
    rect.size.height += self.keyboardBounds.size.height;
    self.view.frame = rect;
    [UIView commitAnimations];
    
}

@end
