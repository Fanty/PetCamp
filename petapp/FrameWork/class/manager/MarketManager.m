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

@implementation MarketManager


-(AsyncTask*)storeItemList:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager storeItemList:offset]];
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

@end
