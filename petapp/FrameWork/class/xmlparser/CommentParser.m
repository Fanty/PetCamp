//
//  CommentParser.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "CommentParser.h"

#import "CommentModel.h"
#import "PetUser.h"

@implementation CommentParser
- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* elements=[rootElement nodesForXPath:@"comments/comment" error:nil];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            CommentModel* model=[[CommentModel alloc] init];
            PetUser* user=[[PetUser alloc] init];
            model.petUser=user;
            [user release];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"id"]){
                    model.cid=[_element stringValue];
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
                else if([[_element name] isEqualToString:@"sex"]){
                    model.petUser.sex=[_element boolValue];
                }
                else if([[_element name] isEqualToString:@"content"]){
                    model.content=[_element stringValue];
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
