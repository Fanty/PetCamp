//
//  MarketParser.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketParser.h"

#import "ChoiceModel.h"

@implementation MarketParser
- (void)onParse: (GDataXMLElement*) rootElement{
    NSArray* elements=[rootElement nodesForXPath:@"items/item" error:nil];
    if([elements count]>0){
        NSMutableArray* list=[[NSMutableArray alloc] init];
        for(GDataXMLElement* element in elements){
            ChoiceModel* model=[[ChoiceModel alloc] init];
            NSArray* _elements=[element children];
            for(GDataXMLElement* _element in _elements){
                if([[_element name] isEqualToString:@"id"]){
                    model.mid=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"type"]){
                    model.type=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"image"]){
                    model.imageUrl=[_element stringValue];
                }
                else if([[_element name] isEqualToString:@"price"]){
                    model.price=[[_element stringValue] floatValue];
                }
                else if([[_element name] isEqualToString:@"link"]){
                    model.link=[_element stringValue];
                    
                }
                else if([[_element name] isEqualToString:@"title"]){
                    model.title=[_element stringValue];
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
