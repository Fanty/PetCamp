//
//  PathUtils.m
//  SVW_STAR
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PathUtils.h"

@implementation PathUtils

+(NSString*) localDBSqlite{
    NSString* root=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* databasePath=[root stringByAppendingPathComponent:@"dbs"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:databasePath]){
        [fileManager createDirectoryAtPath:databasePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [databasePath stringByAppendingPathComponent:@"dbs.sqlite"];
}

+(NSString*) resourceDBSqlite{
    return [[NSBundle mainBundle] pathForResource:@"dbs" ofType:@"sqlite"];
    
}

+(NSString*) countryPath{
    return [[NSBundle mainBundle] pathForResource:@"country" ofType:@"xml"];
}

+(NSString*) cacheUpdateTimeFile{
    NSString* root=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* databasePath=[root stringByAppendingPathComponent:@"dbs"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:databasePath]){
        [fileManager createDirectoryAtPath:databasePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [databasePath stringByAppendingPathComponent:@"cut.tmp"];

}


@end
