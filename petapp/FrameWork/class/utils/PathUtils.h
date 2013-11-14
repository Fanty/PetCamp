//
//  PathUtils.h
//  SVW_STAR
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathUtils : NSObject
+(NSString*) localDBSqlite;
+(NSString*) resourceDBSqlite;
+(NSString*) countryPath;
+(NSString*) cacheUpdateTimeFile;
@end
