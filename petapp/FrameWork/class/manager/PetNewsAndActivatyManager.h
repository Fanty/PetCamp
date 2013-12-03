//
//  PetNewsAndActivaty.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AsyncTask;
@class ActivatyModel;
@interface PetNewsAndActivatyManager : NSObject

-(AsyncTask*)petNewsList:(int)offset;

-(AsyncTask*)createPetNews:(NSString*)content images:(NSString*)images src_post_id:(NSString*)scr_post_id;

-(AsyncTask*)myPetNewsList:(int)offset;

-(AsyncTask*)petNewsCommentList:(NSString*)pid offset:(int)offset;

-(AsyncTask*)createPetNewsComment:(NSString*)pid content:(NSString*)content;

-(AsyncTask*)petNewsDetail:(NSString*)pid;

-(AsyncTask*)likePost:(NSString*)pid;

-(void)attentionActivaty:(ActivatyModel*)model;

-(NSArray*)myAttentionActivaty;

-(AsyncTask*)createActivity:(NSString*)title content:(NSString*)content images:(NSString*)images
start_date:(NSDate*)start_date end_date:(NSDate*)end_date join_date:(NSDate*)join_date;

-(AsyncTask*)joinActivity:(NSString*)aid;

-(AsyncTask*)createActivityComment:(NSString*)aid content:(NSString*)content;

-(AsyncTask*)activityList:(int)offset;

-(AsyncTask*)activtyDetail:(NSString*)aid;

-(AsyncTask*)activtyCommentList:(NSString*)aid offset:(int)offset;


-(AsyncTask*)myJoinActivaty:(int)offset;

-(AsyncTask*)petNewsListByUser:(NSString*)uid offset:(int)offset;

-(AsyncTask*)deletePost:(NSString*)pid;

-(AsyncTask*)deleteActivity:(NSString*)aid;


-(AsyncTask*)emailMessage:(int)offset;

-(AsyncTask*)summary;

@end
