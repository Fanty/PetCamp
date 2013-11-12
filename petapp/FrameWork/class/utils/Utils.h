//
//  Utils
//  PetNews
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(float)systemVersion;
+(BOOL)isPureInt:(NSString*)string;
+ (NSString *)md5:(NSString *)str;
+(BOOL)isIPad;
@end
