//
//  StoreTypeParser.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "StoreTypeParser.h"

#import "StoreType.h"

@implementation StoreTypeParser

- (void)onParse: (GDataXMLElement*) rootElement{
    NSArray* elements=[rootElement nodesForXPath:@"store_types/store_type" error:nil];
    
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            StoreType* model=[[StoreType alloc] init];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"id"]){
                    model.sid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"name"]){
                    model.name=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"code"]){
                    model.code=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"ordering"]){
                    model.ordering=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"logo_path"]){
                    model.logo_path=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"description"]){
                    model.desc=[_element stringValue];
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
