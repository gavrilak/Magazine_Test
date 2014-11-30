//
//  DSReview.m
//  Magazine_Test
//
//  Created by Dima on 11/22/14.
//  Copyright (c) 2014 Dima Soldatenko. All rights reserved.
//

#import "DSReview.h"

@implementation DSReview

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.rw_id = [[responseObject objectForKey:@"id"]stringValue] ;
        self.product= [[responseObject objectForKey:@"product"]stringValue];
        self.user = [[responseObject objectForKey:@"created_by"]objectForKey:@"username"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        self.date= [dateFormat dateFromString:[responseObject objectForKey:@"created_at"]];
        if (self.date == nil){
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            self.date= [dateFormat dateFromString:[responseObject objectForKey:@"created_at"]];
        }
        self.rate = [[responseObject objectForKey:@"rate"] stringValue];
        self.text = [responseObject objectForKey:@"text"];
    }
    return self;
}

- (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize:16.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}



@end
