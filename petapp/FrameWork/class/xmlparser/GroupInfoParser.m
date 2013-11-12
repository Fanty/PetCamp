//
//  GroupInfoParser.m
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "GroupInfoParser.h"
#import "GroupModel.h"
#import "PetUser.h"

@implementation GroupInfoParser

- (void)onParse: (GDataXMLElement*) rootElement{

    NSArray* array = [rootElement nodesForXPath:@"groups/group" error:nil];
    if([array count]>0){
        NSMutableArray* list = [[NSMutableArray alloc] init];

        for(GDataXMLElement* element in array){
            
            GroupModel* groupModel = [[GroupModel alloc] init];
            PetUser* userModel = [[PetUser alloc] init];
            NSArray* infoArray = [element children];
            for(GDataXMLElement* groupElement in infoArray){
                
                if([[groupElement name] isEqualToString:@"id"]){
                    groupModel.groupId = [groupElement stringValue];
                }
                else if([[groupElement name] isEqualToString:@"group_name"]){
                    groupModel.groupName = [groupElement stringValue];
                }
                else if([[groupElement name] isEqualToString:@"type"]){
                    groupModel.type =  [groupElement boolValue];
                }
                else if([[groupElement name] isEqualToString:@"available"]){
                    
                }
                else if([[groupElement name] isEqualToString:@"user_count"]){
                    groupModel.user_count = [groupElement intValue];
                }
                else if([[groupElement name] isEqualToString:@"uid"]){
                    userModel.uid = [groupElement stringValue];
                }
                else if([[groupElement name] isEqualToString:@"image"]){
                    userModel.imageHeadUrl = [groupElement stringValue];
                }
                else if([[groupElement name] isEqualToString:@"nickname"]){
                    userModel.nickname = [groupElement stringValue];
                }
            }
            groupModel.petUser = userModel;
            [userModel release];
            [list addObject:groupModel];
            [groupModel release];
        }
        [result release];
        result = [list retain];
        [list release];

    }
}


@end
