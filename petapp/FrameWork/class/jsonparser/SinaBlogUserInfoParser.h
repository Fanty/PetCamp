//
//  SinaBlogUserInfoParser.h
//  PetNews
//
//  Created by GT mac_5 on 13-8-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "JsonParser.h"

@interface SinaBlogUserInfoParser : JsonParser

-(void)onParser:(NSDictionary*)jsonMap;

@end
