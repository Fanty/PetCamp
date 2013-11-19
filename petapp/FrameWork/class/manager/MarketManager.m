//
//  MarketManager.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketManager.h"
#import "AsyncTask.h"
#import "HTTPRequest.h"
#import "MarketParser.h"
#import "ApiManager.h"
#import "StoreTypeParser.h"

@implementation MarketManager

-(AsyncTask*)storeItemList:(NSString*)type_id offset:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager storeItemList:type_id offset:offset]];
    task.parser=[[[MarketParser alloc] init] autorelease];
    [task start];

    return task;
}

-(AsyncTask*)addStoreItemPageview:(NSString*)mid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager addStoreItemPageview:mid]];
    [task.request setTimeOutSeconds:5.0f];
    task.request.persistentConnectionTimeoutSeconds=5.0f;
    [task start];
    
    return task;

}

-(AsyncTask*)storeTypeList{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager storeTypeListApi]];
    task.parser=[[[StoreTypeParser alloc] init] autorelease];
    [task start];
    return task;

}

@end
