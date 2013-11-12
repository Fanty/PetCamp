//
//  AsyncTask.m
//  SVW_STAR
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "AsyncTask.h"
#import "ASIHTTPRequest.h"
#import "ApiError.h"
#import "ThreadTask.h"

@interface AsyncTask()

@property(nonatomic,retain) ThreadTask* threadTask;

-(void)finish;
@end

@implementation AsyncTask
@synthesize request;
-(void)dealloc{
    self.threadTask=nil;
    self.request=nil;
    self.parser=nil;
    [super dealloc];
}

-(void)cancel{
    self.finishBlock=nil;
    [self.threadTask cancel];
    [self.request cancel];
    [self.request setCompletionBlock:nil];
    [self.request setFailedBlock:nil];
}

-(void)finish{
    if(self.parser!=nil){
        self.threadTask=[ThreadTask asyncStart:^{
            
            [self.parser parse:[self.request responseData]];
        } end:^{
            if(self.finishBlock!=nil){
                self.finishBlock();
            }
            [self cancel];
        }];
    }
    else{
        if(self.finishBlock!=nil){
            self.finishBlock();
        }
        [self cancel];
    }

}

-(void)start{
    [self.request setCompletionBlock:^{
#ifdef DEBUG
        DLog(@"success xml:%@",[self.request responseString]);
#endif
        [self finish];
    }];
    
    [self.request setFailedBlock:^{
#ifdef DEBUG
        DLog(@"failed error:%@",[self.request error]);
#endif
        [self finish];
    }];
    [self.request startAsynchronous ];

}

-(id)result{
    return [self.parser getResult];
}

-(ApiError*)error{
    return [self.parser getError];
}

-(BOOL)status{
    return [self.parser getError].status;
}

-(NSString*)errorMessage{
    if([[self.parser getError].errorMessage length]>0)
        return [self.parser getError].errorMessage;
    else
        return lang(@"error_http");
}

-(NSData*)responseData{
    return [self.request responseData];
}

@end



