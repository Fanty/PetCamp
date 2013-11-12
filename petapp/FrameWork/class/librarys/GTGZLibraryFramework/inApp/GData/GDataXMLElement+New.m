//
//  GDataXMLNode+PetNews.m
//  iPhone_PetNews
//
//  Created by Henry.Yu on 17/10/12.
//  Copyright (c) 2012年 GTGZ. All rights reserved.
//

#import "GDataXMLElement+New.h"

@implementation GDataXMLElement (New)

- (GDataXMLElement *)nodeForXPath:(NSString *)xpath namespaces:(NSDictionary *)namespaces error:(NSError **)error{
    
    NSArray *nodes = [self nodesForXPath:xpath namespaces:namespaces error:error];
    if (nodes.count>0) {
        return [nodes objectAtIndex:0];
    }
    return nil;
}

- (GDataXMLElement *)nodeForXPath:(NSString *)xpath error:(NSError **)error{
    NSArray *nodes = [self nodesForXPath:xpath error:error];
    if (nodes.count>0) {
        return [nodes objectAtIndex:0];
    }
    return nil;
}


- (BOOL)boolValue{
    NSString *str = [[self stringValue] lowercaseString];
    BOOL result = NO;
    if ([str isEqualToString:@"true"] ||[self intValue]==1){
        result = YES;
    }
    return result;
}

- (NSInteger)intValue{
    NSString *str = [self stringValue];
    return [str intValue];
}

- (NSDate*) dateValueFromNSTimeInterval{
    NSTimeInterval time = [[self stringValue] doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSDate*) dateValueFromTimeIntervalSince1970{

    return [NSDate dateWithTimeIntervalSince1970:[[self stringValue] intValue]];
}

- (NSDate*) dateValue:(NSString*) dateFormatStr{
    
    NSString *strValue = [NSString stringWithFormat:@"%@-0700",[self stringValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatStr;
    NSDate *date = [dateFormatter dateFromString:strValue];
    [dateFormatter release];
    return date;
//
//    NSString* str=[self stringValue];
//    if([str length]>10){
//        NSRange range;
//        range.length=1;
//        range.location=str.length-3;
//        str=[str stringByReplacingCharactersInRange:range withString:@""];
//        
//        NSDateFormatter* format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:dateFormatStr];
//        
//        NSDate* date = [format dateFromString:str];
//        
//        [format release];
//        
//        return date;
//    }
//
//    return nil;
}

@end
