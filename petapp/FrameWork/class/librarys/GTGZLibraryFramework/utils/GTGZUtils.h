//
//  GTGZUtils.h
//  GTGZLibrary
//
//  Created by fanty on 13-3-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

@interface GTGZUtils : NSObject

+(UIColor*)colorConvertFromString:(NSString*)value;
+(NSString*)convertStringFromDate:(NSDate*)date;
+(NSString*)trim:(NSString*)value;
+(UIImage*)imageWithThumbnail:(UIImage *)image size:(CGSize)thumbSize;
+(UIImage *)imageFromView:(UIView *)view;
+(UIImage*)imageWithShadow:(UIImage *)initialImage shadowOffset:(CGSize)shadowOffset
             shadowOpacity:(float) shadowOpacity;


+(BOOL)isValidateEmail:(NSString *)email;


+ (NSString *) stringFromMD5:(NSString*)key;

+(NSString*)macAddress;

+(NSString*) uuid;

@end
