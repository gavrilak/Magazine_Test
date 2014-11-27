//
//  DSProductViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSProductViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DSReview.h"
#import "DSServerManager.h"
#import "DSReviewCell.h"
#import "DSProductCell.h"
#import "DSRateView.h"

@interface DSProductViewController ()

   @property (strong, nonatomic) NSArray* reviewsArray;

@end

@implementation DSProductViewController

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


#pragma mark - API

- (void) getReviewsFromServer {
    
    [[DSServerManager sharedManager] getReviewForProduct:self.product.pr_id onSuccess:^(NSArray *reviews) {
        self.reviewsArray = [NSArray arrayWithArray:reviews];
        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.reviewsArray count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
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
        
    }
    
    else{
    
      
        DSReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierReview];
    
        if (!cell) {
            cell = [[DSReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierReview];}
    
        DSReview* review = [self.reviewsArray objectAtIndex:indexPath.row-1];
      
        cell.userLabel.text = review.user;
        cell.postLabel.text = review.text;
        NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
        [objDateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        cell.dateLabel.text =  [objDateFormatter stringFromDate:review.date];
        cell.rateView.editable = false;
        cell.rateView.rating = [review.rate floatValue];
    
        cell.rateView.notSelectedImage = [UIImage imageNamed:@"zvezda_empty.png"];
        cell.rateView.halfSelectedImage = [UIImage imageNamed:@"zvezda_half.png"];
        cell.rateView.fullSelectedImage = [UIImage imageNamed:@"zvezda_full.png"];
        cell.rateView.maxRating = 5;
         return cell;
    }
   
}


@end
