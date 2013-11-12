//
//  BannerManager.m
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BannerManager.h"
#import "AsyncTask.h"
#import "ApiManager.h"
#import "HTTPRequest.h"
#import "BannerParser.h"
#import "DataCenter.h"

#define PETNEWS_BANNER_ID  @"petnews"
#define MARKET_BANNER_ID   @"market"
#define ACTIVATY_BANNER_id @"activaty"

@interface BannerManager()
-(void)loadPetNewsBanner;
-(void)loadMarketBanner;
-(void)loadActivatyBanner;
@end

@implementation BannerManager

-(id)init{
    self=[super init];
    if(self){
        [self loadPetNewsBanner];
        [self loadMarketBanner];
        [self loadActivatyBanner];
    }
    return  self;
    
}


-(void)loadPetNewsBanner{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[BannerParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager adBannerList:PETNEWS_BANNER_ID]];
    task.request=request;
    [task start];
    
    [task setFinishBlock:^{
        if([task result]!=nil){
            [DataCenter sharedInstance].petNewsBannerList=[task result];
            [[NSNotificationCenter defaultCenter] postNotificationName:BannerUpdateNotification object:@"petnews"];
        }
        
        [self performSelector:@selector(loadPetNewsBanner) withObject:nil afterDelay:60.0f];
    }];
}

-(void)loadMarketBanner{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[BannerParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager adBannerList:MARKET_BANNER_ID]];
    task.request=request;
    [task start];
    
    [task setFinishBlock:^{
        if([task result]!=nil){
            [DataCenter sharedInstance].marketBannerList=[task result];
            [[NSNotificationCenter defaultCenter] postNotificationName:BannerUpdateNotification object:@"market"];
        }

        [self performSelector:@selector(loadMarketBanner) withObject:nil afterDelay:60.0f];

    }];
}

-(void)loadActivatyBanner{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[BannerParser alloc] init] autorelease];
    
    HTTPRequest* request=[HTTPRequest requestWithURL:[ApiManager adBannerList:ACTIVATY_BANNER_id]];
    task.request=request;
    [task start];
    
    [task setFinishBlock:^{
        if([task result]!=nil){
            [DataCenter sharedInstance].activatyBannerList=[task result];
            [[NSNotificationCenter defaultCenter] postNotificationName:BannerUpdateNotification object:@"activaty"];
        }
        [self performSelector:@selector(loadActivatyBanner) withObject:nil afterDelay:60.0f];

    }];
}

@end
