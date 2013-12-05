//
//  GroupMessageParser.m
//  PetNews
//
//  Created by Fanty on 13-11-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupMessageParser.h"
#import "GroupMessage.h"
#import "PetUser.h"

@implementation GroupMessageParser

- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* array = [rootElement nodesForXPath:@"messages/message" error:nil];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for(int i=[array count]-1;i>=0;i--){
        GDataXMLElement* element=[array objectAtIndex:i];
        GroupMessage* msgModel = [[GroupMessage alloc] init];
        PetUser* userModel = [[PetUser alloc] init];
        NSArray* infoArray = [element children];
        for(GDataXMLElement* msgElement in infoArray){
            
            if([[msgElement name] isEqualToString:@"content"]){
                msgModel.content = [msgElement stringValue];
            }
            else if([[msgElement name] isEqualToString:@"createtime"]){
                msgModel.createtime = [msgElement dateValueFromNSTimeInterval];
            }
            else if([[msgElement name] isEqualToString:@"id"]){
                msgModel.msgId = [msgElement stringValue];
            }
            else if([[msgElement name] isEqualToString:@"image"]){
                NSString* image=[msgElement stringValue];
                if([image length]>2){
                    msgModel.content=image;
                    msgModel.isImage=YES;
                }
            }
            else if([[msgElement name] isEqualToString:@"sender"]){
                NSArray* __array=[msgElement children];
                
                for(GDataXMLElement* __element in __array){
                    if([[__element name] isEqualToString:@"id"]){
                        userModel.uid = [__element stringValue];
                    }
                    else if([[__element name] isEqualToString:@"nickname"]){
                        userModel.nickname = [__element stringValue];
                    }
                    else if([[__element name] isEqualToString:@"image"]){
                        userModel.imageHeadUrl = [__element stringValue];
                    }
                    
                }
            }
        }
        msgModel.sender = userModel;
        [userModel release];
        [list addObject:msgModel];
        [msgModel release];
    }
    
    
    [result release];
    result = [list retain];
    [list release];
    
    
    
    
}

@end
