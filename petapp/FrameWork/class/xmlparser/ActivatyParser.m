//
//  ActivatyParser.m
//  PetNews
//
//  Created by fanty on 13-8-21.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivatyParser.h"
#import "ActivatyModel.h"
#import "PetUser.h"
@implementation ActivatyParser


- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement nodesForXPath:@"items/item" error:nil];
    if([elements count]<1)
        elements=[rootElement nodesForXPath:@"item" error:nil];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            ActivatyModel* model=[[ActivatyModel alloc] init];
            PetUser* user=[[PetUser alloc] init];
            model.petUser=user;
            [user release];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                
                if([[_element name] isEqualToString:@"id"]){
                    model.aid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"uid"]){
                    model.petUser.uid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"nickname"]){
                    model.petUser.nickname=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"user_image"]){
                    model.petUser.imageHeadUrl=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"title"]){
                    model.title=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"description"]){
                    model.desc=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"images"]){
                    NSString* urls=[_element stringValue];
                    if([urls length]>3)
                        model.imageUrls=[urls componentsSeparatedByString:@","];
                }
                else if([[_element name] isEqualToString:@"comment_count"]){
                       model.commandCount=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"rate_count"]){
                    model.laudCount=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"createdate"]){
                    model.createdate=[_element dateValueFromNSTimeInterval];
                }
                else if([[_element name] isEqualToString:@"updatedate"]){
                    model.updatedate=[_element dateValueFromNSTimeInterval];
                }
                else if([[_element name] isEqualToString:@"startdate"]){
                    model.startdate=[_element dateValueFromNSTimeInterval];
                }
                else if([[_element name] isEqualToString:@"enddate"]){
                    model.enddate=[_element dateValueFromNSTimeInterval];
                }
                else if([[_element name] isEqualToString:@"max_user_count"]){
                    model.maxCount=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"user_count"]){
                    model.activate_count=[_element intValue];
                }

            }
        
            [list addObject:model];
            [model release];
        }
        [result release];
        result=[list retain];
        [list release];
    }
}


@end



