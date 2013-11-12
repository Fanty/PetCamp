//
//  GDataXMLNode+PetNews.h
//  iPhone_PetNews
//
//  Created by Henry.Yu on 17/10/12.
//  Copyright (c) 2012年 GTGZ. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLNode (New)

- (GDataXMLElement *)nodeForXPath:(NSString *)xpath namespaces:(NSDictionary *)namespaces error:(NSError **)error;

- (GDataXMLElement *)nodeForXPath:(NSString *)xpath error:(NSError **)error;

- (BOOL)boolValue;

- (NSInteger)intValue;

- (NSDate*) dateValueFromNSTimeInterval;

- (NSDate*) dateValue:(NSString*) dateFormatStr;

@end
