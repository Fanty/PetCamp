//
//  ContactGroupManager.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactGroupManager.h"
#import "AsyncTask.h"
#import "HTTPRequest.h"
#import "ApiManager.h"
#import "MessageParser.h"
#import "ContactParser.h"
#import "AppDelegate.h"
#import "PetUser.h"
#import "GroupInfoParser.h"
#import "DataCenter.h"

@implementation ContactGroupManager

-(AsyncTask*)createGroup:(NSString*)groupName{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createGroup]];
    [request setPostValue:groupName forKey:@"groupname"];
    
    task.request=request;
    [task start];
    
    return task;
    
}

-(AsyncTask*)myBoardList:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[MessageParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager myBoardList:offset token:[DataCenter sharedInstance].user.token]];
    
    task.request=request;
    [task start];
    return task;
    
}

-(AsyncTask*)createBoard:(NSString*)friend_id content:(NSString*)content{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createBoard]];
    [request setPostValue:friend_id forKey:@"friend_id"];
    [request setPostValue:content forKey:@"content"];

    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)friendList:(NSString*)groupId{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[ContactParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager friendList:[DataCenter sharedInstance].user.token groupId:groupId]];
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)makeFriend:(NSString*)friend_id{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager makeFriend]];
    [request setPostValue:friend_id forKey:@"friend_id"];    
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)userDetail:(NSString*)uid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[ContactParser alloc] init] autorelease];
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager userDetail:uid token:[DataCenter sharedInstance].user.token]];
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)nearUser:(float)longitude latitude:(float)latitude offset:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[ContactParser alloc] init] autorelease];
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager nearUser:longitude latitude:latitude offset:offset token:[DataCenter sharedInstance].user.token]];
    task.request=request;
    [task start];
    return task;
}

-(AsyncTask*)groupList{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[GroupInfoParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager groupList:[DataCenter sharedInstance].user.token]];
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)addGroupUser:(NSString*)group_id friend_id:(NSString*)friend_id{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager addGroupUser]];
    [request setPostValue:group_id forKey:@"id"];
    [request setPostValue:friend_id forKey:@"friend_id"];
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)addGroupUsers:(NSString*)group_id friends:(NSArray*)friends{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager addGroupUsers]];
    [request setPostValue:group_id forKey:@"id"];
    
    NSMutableString* str=[[NSMutableString alloc] initWithCapacity:1];
    
    [friends enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop){
        [str appendString:obj];
        if(idx!=[friends count]-1)
            [str appendString:@","];
    }];
    [request setPostValue:str forKey:@"friend_id"];
    [str release];
    
    task.request=request;
    [task start];
    return task;
}

-(AsyncTask*)searchGroup:(NSString*)keyword offset:(int)offset{
    if([keyword length]<1)
        keyword=@"";
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[GroupInfoParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager searchGroup:keyword offset:offset]];
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)searchUser:(NSString*)keyword offset:(int)offset{
    if([keyword length]<1)
        keyword=@"";
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[ContactParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager searchUser:keyword offset:offset]];
    task.request=request;
    [task start];
    return task;

}

@end
