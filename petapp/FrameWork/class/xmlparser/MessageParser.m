//
//  MessageParser.m
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "MessageParser.h"
#import "MessageModel.h"
#import "PetUser.h"

@implementation MessageParser

- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* array = [rootElement nodesForXPath:@"messages/message" error:nil];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for(GDataXMLElement* element in array){
        MessageModel* msgModel = [[MessageModel alloc] init];
        PetUser* userModel = [[PetUser alloc] init];
        NSArray* infoArray = [element children];
        for(GDataXMLElement* msgElement in infoArray){
            
            if([[msgElement name] isEqualToString:@"content"]){
                msgModel.content = [msgElement stringValue];
            }
            else if([[msgElement name] isEqualToString:@"createtime"]){
                msgModel.createdate = [msgElement dateValueFromNSTimeInterval];
            }
            else if([[msgElement name] isEqualToString:@"user"]){
                NSArray* __array=[msgElement children];
                
                for(GDataXMLElement* __element in __array){
                    if([[__element name] isEqualToString:@"uid"]){
                        userModel.uid = [__element stringValue];
                    }
                    else if([[__element name] isEqualToString:@"nickname"]){
                        userModel.nickname = [__element stringValue];
                    }
                    else if([[__element name] isEqualToString:@"sex"]){
                        userModel.sex = [__element boolValue];
                    }

                }
            }
            else if([[msgElement name] isEqualToString:@"createdate"]){ //date
                msgModel.createdate = [msgElement dateValueFromNSTimeInterval] ;
            }

        }
        msgModel.friendUser = userModel;
        [userModel release];
        [list addObject:msgModel];
        [msgModel release];
    }
    
    
    [result release];
    result = [list retain];
    [list release];
}

@end
