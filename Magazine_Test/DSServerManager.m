//
//  DSServerManager.m
//  Weather_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSServerManager.h"
#import "DSProduct.h"
#import "DSReview.h"
#import "AFNetworking.h"


@interface DSServerManager ()

@property (strong,nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong,nonatomic) NSMutableArray * weatherForecast;

@end

@implementation DSServerManager

+ (DSServerManager *)sharedManager {
    
    static DSServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DSServerManager alloc]init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://smktesting.herokuapp.com/"]];
        self.weatherForecast= [NSMutableArray array];
    }
    return self;
}

/*- (void)getForecastDaysCount :(NSInteger) count woeid: (NSString *) woeidCity onSuccess:(void (^) (NSMutableArray *weatherForecast)) success onFailure:(void (^) (NSError *error)) failure {

    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:woeidCity,@"w",@"c",@"u", nil];
    self.requestOperationManager.responseSerializer =[AFXMLParserResponseSerializer serializer];
    self.requestOperationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@ "application/rss+xml"  ];
    [self.requestOperationManager GET:@"api/products" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSXMLParser* XmlParser = (NSXMLParser*)responseObject;
        XmlParser.delegate = self;
        [XmlParser parse] ;
        
       [self.weatherForecast removeObjectsInRange:NSMakeRange(count,[self.weatherForecast count]-count)];
        success([self.weatherForecast copy]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];

} */


- (void) getProductsOnSuccess:(void(^)(NSArray* products)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    [self.requestOperationManager
     GET:@"api/products"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
       //  NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
        NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in responseObject) {
             DSProduct* product = [[DSProduct alloc] initWithDictionary:dict];
             [objectsArray addObject:product];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
    
}

- (void) getReviewForProduct:(NSString*) pr_id onSuccess:(void(^)(NSArray* reviews)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    [self.requestOperationManager
     GET:[@"api/reviews/" stringByAppendingString:pr_id]
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         //  NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in responseObject) {
             DSReview* review = [[DSReview alloc] initWithDictionary:dict];
             [objectsArray addObject:review];
         }
         
         if (success) {
             success(objectsArray);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
    
}


@end
