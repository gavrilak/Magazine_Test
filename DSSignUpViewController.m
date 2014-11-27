//
//  DSSignUpViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/27/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSSignUpViewController.h"
#import "DSTextField.h"

#define KEYBOARD_OFFSET 70.0

@interface DSSignUpViewController ()


@property (weak, nonatomic) IBOutlet DSTextField *loginTextField;
@property (weak, nonatomic) IBOutlet DSTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet DSTextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UILabel *passwordConfirmationLabel;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
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

- (IBAction)closeViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



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
       
        
        [self performSegueWithIdentifier:@"ShowNewUser" sender:self];
    }
}




#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)keyboardWillShow
{
    [self setViewMovedUp:YES];
}

-(void)keyboardWillHide
{
    [self setViewMovedUp:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if  (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (IBAction)confirmPasswordChanged:(id)sender
{
    UITextField *textfield = (UITextField *)sender;
    
    [self.passwordConfirmationLabel setHidden:[self.passwordTextField.text isEqualToString:textfield.text]];
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= KEYBOARD_OFFSET;
        rect.size.height += KEYBOARD_OFFSET;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += KEYBOARD_OFFSET;
        rect.size.height -= KEYBOARD_OFFSET;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



@end
