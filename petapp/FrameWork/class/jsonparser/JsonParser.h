//
//  SVWJsonParser.h
//  iOS_SVW_Accessories
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 Henry.Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InterfaceUtils.h"

@class ApiError;
@interface JsonParser : NSObject<ParserInterface>{
    id result;
    ApiError* error;
    
}

-(void)onParser:(NSDictionary*)jsonMap;


@end
