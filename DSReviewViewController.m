//
//  DSProductViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSReviewViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DSReview.h"
#import "DSServerManager.h"
#import "DSReviewCell.h"
#import "DSProductCell.h"
#import "DSRateView.h"
#import "DSAddReviewCell.h"

@interface DSReviewViewController ()

   @property (strong, nonatomic) NSArray* reviewsArray;

@end

@implementation DSReviewViewController

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
  
    [self  getReviewsFromServer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addReview:(UIButton *)sender {
    if([[DSServerManager sharedManager] userIsLogIn]){
        DSAddReviewViewController *vc = [[DSAddReviewViewController alloc]init];
        vc.delegate = self;
        vc.pr_id= self.product.pr_id;
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nv animated:YES completion:nil];
    }
    
}
#pragma mark - API

- (void) getReviewsFromServer {
    
    [[DSServerManager sharedManager] getReviewForProduct:self.product.pr_id onSuccess:^(NSArray *reviews) {
        self.reviewsArray = [NSArray arrayWithArray:reviews];
        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    }];
    
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DSReview* review;

    switch (indexPath.row) {
        case 0:
            return 100;
            break;
        case 1:
            return 30;
            break;
        default:
          review = [self.reviewsArray objectAtIndex:indexPath.row-2];
          return [review heightForText:review.text] + 65;
          break;
    }
    
    return 0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.reviewsArray count] + 2  ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString* identifierAddReview = @"addReview";
    static NSString* identifierReview = @"Review";
    static NSString* identifierProduct = @"Product";
    
    if (indexPath.row == 0){
        
        DSProductCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierProduct];
        
        if (!cell) {
            cell = [[DSProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierProduct];}
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://smktesting.herokuapp.com/static/"stringByAppendingString: self.product.img]]];
         
         __weak DSProductCell* weakCell = cell;
         
         cell.imageView.image  = nil;
         cell.nameLabel.text = self.product.title;
         cell.infoLabel.text = self.product.text;
         [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         weakCell.imageView.image= image;
         [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         NSLog(@"error = %@", [error localizedDescription]);
         }];
         return cell;
        
    }    else  if (indexPath.row == 1) {
        
        DSAddReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierAddReview];
        
        if (!cell) {
            cell = [[DSAddReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierAddReview];}
        
        [cell.addReviewButton addTarget:self action:@selector(addReview:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
    
      
        DSReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierReview];
    
        if (!cell) {
            cell = [[DSReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierReview];}
    
        DSReview* review = [self.reviewsArray objectAtIndex:indexPath.row-2];
      
        cell.userLabel.text = review.user;
        cell.postLabel.text = review.text;
        NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
        [objDateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        cell.dateLabel.text =  [objDateFormatter stringFromDate:review.date];
        cell.rateView.editable = false;
        cell.rateView.rating = [review.rate floatValue];
        cell.rateView.notSelectedImage = [UIImage imageNamed:@"star_empty.png"];
        cell.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half.png"];
        cell.rateView.fullSelectedImage = [UIImage imageNamed:@"star_full.png"];
        cell.rateView.maxRating = 5;
         return cell;
    }
   
}
#pragma mark - TTAddPostDelegete

- (void)updateData {
    
    [self getReviewsFromServer];   
    
}


@end
