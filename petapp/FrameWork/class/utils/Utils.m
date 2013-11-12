//
//  Utils.m
//  PetNews
//
//  Created by fanty on 13-5-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils


+(BOOL)isIPad{
    return (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad);
}

+(float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}



+ (NSString *)md5:(NSString *)str{
    if(str == nil)
        return nil;
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}


@end
