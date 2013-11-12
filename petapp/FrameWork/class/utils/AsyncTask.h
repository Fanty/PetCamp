//
//  AsyncTask.h
//  SVW_STAR
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceUtils.h"

typedef void (^AsyncTaskBlock)();

@class ASIHTTPRequest;
@class ApiError;

@interface AsyncTask : NSObject
@property(nonatomic,retain)ASIHTTPRequest* request;

@property(nonatomic,retain) id<ParserInterface> parser;

@property (copy, nonatomic) AsyncTaskBlock finishBlock;

-(void)cancel;

-(void)start;

-(id)result;

-(ApiError*)error;

-(BOOL)status;

-(NSString*)errorMessage;

-(NSData*)responseData;

@end


