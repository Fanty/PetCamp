//
//  HTTPRequest.m
//  PetNews
//
//  Created by fanty on 13-8-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "PetUser.h"
#import "DataCenter.h"

#define HTTP_TIMEOUT   10.0f

@implementation HTTPRequest

-(id)init{
    self=[super init];
    
    if(self){
        [self setTimeOutSeconds:HTTP_TIMEOUT];
        self.persistentConnectionTimeoutSeconds=HTTP_TIMEOUT;
        if([[DataCenter sharedInstance].user.token length]>1){
            [self addRequestHeader:@"User-Agent" value:@"Phone OS 6.0; en_us"];
            [self addRequestHeader:@"token" value:[DataCenter sharedInstance].user.token];

        }
    }
    
    
    return  self;
}

-(void)dealloc{
    [super dealloc];
}

@end


@implementation FormDataRequest

- (id)init{
    self = [super init];
    if (self) {
        [self setTimeOutSeconds:HTTP_TIMEOUT];
        self.persistentConnectionTimeoutSeconds=HTTP_TIMEOUT;
        NSString* token=[DataCenter sharedInstance].user.token;
        if([token length]>1){
            [self addRequestHeader:@"User-Agent" value:@"Phone OS 6.0; en_us"];
            [self addRequestHeader:@"token" value:token];
            [self setPostValue:token forKey:@"token"];
        }

    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

@end
