//
//  DSAddReviewViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/29/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSAddReviewViewController.h"
#import "DSRateView.h"
#import "DSServerManager.h"
#import "DSProduct.h"


@interface DSAddReviewViewController () <UITextViewDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UITextView *textView;
@property (strong,nonatomic) DSRateView *rateView;
@property (strong,nonatomic) UIBarButtonItem *done;
@property (assign,nonatomic) CGRect keyboardBounds;


@end

@implementation DSAddReviewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
       
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = 4.0;
    layout.minimumLineSpacing = 4.0;
    layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
   
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideReview:)];
    self.done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addReview:)];
    self.done.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.done;
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UITextView * txtview = [[UITextView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    
    [txtview setDelegate:self];
    [txtview setReturnKeyType:UIReturnKeyDefault];
    [txtview setTag:1];
    txtview.scrollEnabled = NO;
    self.textView = txtview;
    [self.view addSubview:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.rateView = [[DSRateView alloc]init];
    
    self.rateView.frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
    self.rateView.editable = true;
    self.rateView.rating = 0;
    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"star_full.png"];
    self.rateView.maxRating = 5;
    [self.view addSubview:  self.rateView];
    
    [self.textView becomeFirstResponder];
    
}

- (void)keyboardWillShow: (NSNotification *)notification {
    
    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    [self.textView setFrame:CGRectMake(0, 0, self.textView.frame.size.width, self.view.frame.size.height - self.keyboardBounds.size.height - self.rateView.frame.size.height - 10 )];
    [self.rateView setFrame:CGRectMake(0.0f, self.view.frame.size.height - self.keyboardBounds.size.height - self.rateView.frame.size.height - 10,self.rateView.frame.size.width, self.rateView.frame.size.height)];
    [UIView commitAnimations];
}


- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        self.done.enabled = NO;
    } else {
        self.done.enabled = YES;
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
 
}



- (void)hideReview:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addReview:(UIBarButtonItem *)sender {
    
     [[DSServerManager sharedManager] postReviewForProduct:self.pr_id text: self.textView.text rate: self.rateView.rating
        onSuccess:^(NSInteger reviewId) {
            [self.delegate updateData];
        } onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
        }];        
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
