//
//  DSServerManager.m
//  
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//
#import "DSServerManager.h"
#import "AFNetworking.h"
#import "DSAccessToken.h"

@interface DSServerManager ()

@property (strong,nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong, nonatomic) DSAccessToken *accessToken;


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
        
    }
 
    return self;
}



- (void) registerUser:(NSString*) username password:(NSString*) password
            onSuccess:(void(^)(DSUser* user)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     username,       @"username",
     password,   @"password", nil];
    
   
    [self.requestOperationManager
     POST:@"api/register/"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         
         DSUser* user = [[DSUser alloc]initWithServerResponse:responseObject];
        [self getToken:user username:username password:password onSuccess:^(DSAccessToken *token) {
            self.accessToken =token;
            if (success) {
                success(user);
            }
        } onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
        }];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
    
}

- (void) loginUser:(NSString*) username password:(NSString*) password
            onSuccess:(void(^)(id success)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     username,   @"username",
     password,   @"password", nil];
    self.requestOperationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [self.requestOperationManager
     POST:@"login/"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSLog(@"JSON: %@", responseObject);
         
              if (success) {
                 success(responseObject);
            }
        
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     
     }];
}


- (void) getToken:(DSUser*) user username:(NSString*) username password:(NSString*) password onSuccess:(void(^)(DSAccessToken* token)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     user.clientKey,      @"client_id",
     user.clientSecret,   @"client_secret",
     @"password",   @"grant_type",
     username,   @"username",
     password,   @"password",  nil];
    
    self.requestOperationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
   
    [self.requestOperationManager
     POST:@"api/oauth2/access_token/"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         DSAccessToken* token = [[DSAccessToken alloc]initWithServerResponse:responseObject];
                  
         if (success) {
             success(token);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
    
}



- (void) getProductsOnSuccess:(void(^)(NSArray* products)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    [self.requestOperationManager
     GET:@"api/products"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
        
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

- (void) postReviewForProduct:(NSString*) pr_id text:(NSString*)text rate:(NSInteger) rate onSuccess:(void(^)(NSInteger reviewId)) success   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInteger:rate]   ,@"rate",
     text,                                @"text", nil];

  
    self.requestOperationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
      [[self.requestOperationManager  requestSerializer] setValue:[@"Bearer " stringByAppendingString: self.accessToken.token]  forHTTPHeaderField:@"Authorization"];
  
    [self.requestOperationManager
     POST:[@"api/reviews/" stringByAppendingString:pr_id]
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         if (success) {
             success([[responseObject objectForKey:@"review_id"] integerValue]);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
    
}


- (BOOL) userIsLogIn{
    
    if(self.accessToken.token == nil)
        return false;
    else
        return true;
}

@end
