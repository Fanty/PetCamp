//
//  TalkManager.m
//  PetNews
//
//  Created by Fanty on 13-11-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "TalkManager.h"

#import "AsyncTask.h"
#import "HTTPRequest.h"
#import "ApiManager.h"
#import "GroupMessageParser.h"

@implementation TalkManager

-(AsyncTask*)syncTalk:(NSString*)groupId{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager groupMessageList:groupId]];
    task.parser=[[[GroupMessageParser alloc] init] autorelease];
    [task start];
    return task;
}

-(AsyncTask*)sendChat:(NSString*)groupId content:(NSString*)content image:(NSString*)image{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createGroupMessage]];
    [request setPostValue:groupId forKey:@"gid"];
    [request setPostValue:content forKey:@"content"];
    if([image length]>0)
        [request setPostValue:image forKey:@"image"];
    task.request=request;
    XmlParser* parser=[[XmlParser alloc] init];
    task.parser=parser;
    [parser release];
    [task start];
    return task;

}

@end
