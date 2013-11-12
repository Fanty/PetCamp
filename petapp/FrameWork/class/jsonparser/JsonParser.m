//
//  SVWJsonParser.m
//  iOS_SVW_Accessories
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 Henry.Yu. All rights reserved.
//

#import "JsonParser.h"
#import "JSONKit.h"
#import "ApiError.h"

@implementation JsonParser

- (void)dealloc{
    [result release];
    [error release];
    [super dealloc];
}

-(void)parse:(NSData*)data{
    [result release];
    result=nil;
    [error release];
    error=nil;
        
    if([data length]>0){
        NSDictionary *jsonMap = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
            jsonMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }else{
            NSString* jsonStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            jsonMap = [jsonStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            [jsonStr release];
        }
        if(jsonMap!=nil)
            [self onParser:jsonMap];
    }
    
    if(result==nil){
        if(error==nil)
            error=[[ApiError alloc] init];
    }
    
}

-(void)onParser:(NSDictionary*)jsonMap{
    
}

-(id)getResult{
    return result;
}

-(ApiError*)getError{
    return error;
}

@end
