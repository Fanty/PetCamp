//
//  SVWApiError.m
//  iOS_SVW_Accessories
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 Henry.Yu. All rights reserved.
//

#import "ApiError.h"

@implementation ApiError
@synthesize errorCode;
@synthesize errorMessage;
@synthesize status;

-(id)init{
    self=[super init];
    
    self.errorCode = HTTP_ERROR_CODE;
    self.errorMessage = lang(HTTP_ERROR_CODE);
    return self;
}

- (void)dealloc{
    self.errorCode = nil;
    self.errorMessage=nil;
    [super dealloc];
}

@end
