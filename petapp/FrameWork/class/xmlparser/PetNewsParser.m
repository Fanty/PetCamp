//
//  PetNewsParser.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsParser.h"
#import "PetNewsModel.h"
#import "PetUser.h"
@implementation PetNewsParser

- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement nodesForXPath:@"items/item" error:nil];
    if([elements count]<1)
        elements=[rootElement nodesForXPath:@"comment" error:nil];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            PetNewsModel* model=[[PetNewsModel alloc] init];
            PetUser* user=[[PetUser alloc] init];
            model.petUser=user;
            [user release];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"id"]){
                    model.pid=[_element stringValue];
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
                else if([[_element name] isEqualToString:@"content"]){
                    model.desc=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"images"]){
                    NSString* urls=[_element stringValue];
                    if([urls length]>3)
                        model.imageUrls=[urls componentsSeparatedByString:@","];
                }

                
                else if([[_element name] isEqualToString:@"like_count"]){
                    model.laudCount=[_element intValue];
                }
                else if([[_element name] isEqualToString:@"comment_count"]){
                    model.command_count=[_element intValue];

                }
                else if([[_element name] isEqualToString:@"createdate"]){
                    model.createdate=[_element dateValueFromNSTimeInterval];
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
