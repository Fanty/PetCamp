//
//  SVWApiError.h
//  iOS_SVW_Accessories
//
//  Created by fanty on 13-4-28.
//  Copyright (c) 2013年 Henry.Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiError : NSObject
@property(nonatomic,assign) BOOL status;
@property (retain, nonatomic) NSString *errorCode;
@property (retain, nonatomic) NSString *errorMessage;

@end
