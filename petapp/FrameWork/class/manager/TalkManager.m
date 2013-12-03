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
    AsyncTask* task=[[AsyncTask alloc] init];
    task.request=[HTTPRequest requestWithURL:[ApiManager groupMessageList:groupId]];
    task.parser=[[[GroupMessageParser alloc] init] autorelease];
    [task start];
    return task;
}

-(AsyncTask*)sendChat:(NSString*)groupId content:(NSString*)content isImage:(BOOL)isImage{
    AsyncTask* task=[[AsyncTask alloc] init];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createGroupMessage]];
    [request setPostValue:groupId forKey:@"gid"];
    [request setPostValue:content forKey:@"content"];
    task.request=request;
    XmlParser* parser=[[XmlParser alloc] init];
    task.parser=parser;
    [parser release];
    [task start];
    return task;

}

@end
