//
//  DataCenter.m
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "DataCenter.h"

#import "PathUtils.h"



static DataCenter* instance=nil;

@implementation DataCenter

@synthesize user;

@synthesize friendList;
@synthesize fansList;
@synthesize groupList;
@synthesize latitude;
@synthesize longitude;

@synthesize petNewsBannerList;
@synthesize marketBannerList;
@synthesize activatyBannerList;

@synthesize lastestUpdatePetNewsId;

@synthesize lastestUpdateMarketId;

@synthesize lastestUpdateActivatyId;

@synthesize showUpdatePetNews;
@synthesize showUpdateMarket;
@synthesize showUpdateActivaty;


+(DataCenter*)sharedInstance{
    if(instance==nil)
        instance=[[DataCenter alloc] init];
    
    return  instance;
}

-(id)init{
    self=[super init];
    
    if(self){
        [self restore];
    }
    return  self;
}

- (void)dealloc{
    self.friendList=nil;
    self.groupList=nil;
    self.fansList=nil;
    self.lastestUpdatePetNewsId=nil;
    self.lastestUpdateMarketId=nil;
    self.lastestUpdateActivatyId=nil;
    self.user=nil;
    self.petNewsBannerList=nil;
    self.marketBannerList=nil;
    self.activatyBannerList=nil;

    [super dealloc];
}

-(void)restore{
    NSString* path=[PathUtils cacheUpdateTimeFile];
    
    NSString* content=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    if([content length]>1){
        NSArray* array=[content componentsSeparatedByString:@","];
        if([array count]>5){
            self.lastestUpdatePetNewsId=[array objectAtIndex:0] ;
            self.showUpdatePetNews=[[array objectAtIndex:1] boolValue];
            self.lastestUpdateMarketId=[array objectAtIndex:2] ;
            self.showUpdateMarket=[[array objectAtIndex:3] boolValue];
            self.lastestUpdateActivatyId=[array objectAtIndex:4];
            self.showUpdateActivaty=[[array objectAtIndex:5] boolValue];
        }
    }
    [content release];
    
}

-(void)save{
    NSString* content=[NSString stringWithFormat:@"%@,%d,%@,%d,%@,%d",lastestUpdatePetNewsId,showUpdatePetNews,lastestUpdateMarketId,showUpdateMarket,lastestUpdateActivatyId,showUpdateActivaty];
    NSString* path=[PathUtils cacheUpdateTimeFile];

    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)logout{
    self.user=nil;
    self.friendList=nil;
    self.groupList=nil;
    self.fansList=nil;
}


@end
