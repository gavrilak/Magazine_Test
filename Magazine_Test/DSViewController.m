//
//  DSViewController.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSViewController.h"
#import "DSServerManager.h"
#import "DSProduct.h"
#import "DSProductViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DSViewController ()

@property (strong, nonatomic) NSArray* productArray;
@property (assign, nonatomic) NSInteger selectedItem;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.productArray = [NSMutableArray array];
    [self getProructsFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getProructsFromServer {
    
    [[DSServerManager sharedManager] getProductsOnSuccess:^(NSArray *products) {
        self.productArray = [NSArray arrayWithArray:products];
        [self.tableView reloadData];
    
    } onFailure:^(NSError *error, NSInteger statusCode) {
       NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
    }];
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.productArray count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];}
    
    DSProduct* product = [self.productArray objectAtIndex:indexPath.row];
    cell.textLabel.text = product.title;
    cell.detailTextLabel.text = product.text;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://smktesting.herokuapp.com/static/"stringByAppendingString: product.img]]];
        
    __weak UITableViewCell* weakCell = cell;
        
    cell.imageView.image = nil;
        
   [cell.imageView
    setImageWithURLRequest:request
    placeholderImage:nil
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             weakCell.imageView.image = image;
             [weakCell layoutSubviews];
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"error = %@", [error localizedDescription]);
         }];
    

    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedItem = indexPath.row;
    return indexPath;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    DSProductViewController *dc = [segue destinationViewController];
    dc.product = [self.productArray objectAtIndex:self.selectedItem];
    
}
@end
