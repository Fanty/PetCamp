//
//  SettingManager.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SettingManager.h"
#import "PathUtils.h"
#import "SqliteLib.h"

#import "AsyncTask.h"
#import "HTTPRequest.h"

#import "XmlParser.h"
#import "UploadImageParser.h"
#import "ApiManager.h"
#import "AreaParser.h"

@implementation SettingManager

-(void)checkSqliteVersion{
    
    SqliteLib* sqlite=[[SqliteLib alloc] init];
    BOOL newSqlite=YES;
    [sqlite open:[PathUtils localDBSqlite]];
    if([sqlite query:@"select dbVersion from tbl_setting"] && [sqlite next]){
        
        NSString* version=[sqlite stringValue:0];
        if(version!=nil){
            [sqlite open:[PathUtils resourceDBSqlite]];
            [sqlite query:@"select dbVersion from tbl_setting"];
            [sqlite next];
            NSString* _nVersion=[sqlite stringValue:0];
            if([version isEqualToString:_nVersion]){
                newSqlite=NO;
            }
            [sqlite close];
        }
    }
    [sqlite release];
    if(newSqlite){
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        NSData* data=[NSData dataWithContentsOfFile:[PathUtils resourceDBSqlite]];
        [data writeToFile:[PathUtils localDBSqlite] atomically:YES];
        [pool release];
    }
}

-(AsyncTask*)fileUpload:(NSData*)data type:(NSString*)type{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[UploadImageParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager fileUpload]];
    [request setPostValue:type forKey:@"type"];
    [request addData:data withFileName:@"adImage.jpg" andContentType:@"image/jpeg" forKey:@"image"];
    task.request=request;
    [task start];

    return task;

}

-(NSArray*)countryList{
    AreaParser* pareser = [[AreaParser alloc] init];
    [pareser parse:[NSData dataWithContentsOfFile:[PathUtils countryPath]]];
    NSArray* array=[[pareser getResult] retain];
    [pareser release];
    
    return [array autorelease];
}

@end
