//
//  ParserInterface.h
//  SVW_STAR
//
//  Created by fanty on 13-5-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApiError;

@protocol ParserInterface <NSObject>

-(void)parse:(NSData*)data;
-(id)getResult;
-(ApiError*)getError;
@end
