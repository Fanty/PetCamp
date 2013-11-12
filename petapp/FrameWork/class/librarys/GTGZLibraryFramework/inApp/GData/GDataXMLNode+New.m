//
//  GDataXMLNode+PetNews.m
//  iPhone_PetNews
//
//  Created by Henry.Yu on 17/10/12.
//  Copyright (c) 2012年 GTGZ. All rights reserved.
//

#import "GDataXMLNode+New.h"

@implementation GDataXMLNode (New)

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
    NSString *str = [self stringValue];
    BOOL result = NO;
    if ([str isEqualToString:@"true"]){
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
    return [NSDate dateWithTimeIntervalSinceNow:time];
}

- (NSDate*) dateValue:(NSString*) dateFormatStr{
    NSString *strValue = [self stringValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatStr;
    NSDate *date = [dateFormatter dateFromString:strValue];
    [dateFormatter release];
    return date;
}

@end
