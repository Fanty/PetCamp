//
//  PetNewsAndActivaty.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsAndActivatyManager.h"
#import "AsyncTask.h"
#import "HTTPRequest.h"
#import "ApiManager.h"
#import "Utils.h"
#import "CommentParser.h"
#import "PetNewsParser.h"
#import "SqliteLib.h"
#import "PathUtils.h"
#import "ActivatyModel.h"
#import "PetUser.h"
#import "MessageParser.h"
#import "ActivatyParser.h"
#import "DataCenter.h"

@implementation PetNewsAndActivatyManager

-(AsyncTask*)petNewsList:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager petNewsList:offset]];
    task.parser=[[[PetNewsParser alloc] init] autorelease];
    [task start];


    return task;

}

-(AsyncTask*)createPetNews:(NSString*)content images:(NSString*)images src_post_id:(NSString*)scr_post_id{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createPetNews]];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:([images length]>0?images:@"") forKey:@"images"];
    if([scr_post_id length]>0)
        [request setPostValue:scr_post_id forKey:@"src_post_id"];
    task.request=request;
    [task start];

    return task;

}

-(AsyncTask*)myPetNewsList:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager myPetNewsList:[DataCenter sharedInstance].user.token offset:offset]];
    task.parser=[[[PetNewsParser alloc] init] autorelease];
    [task start];

    return task;

}

-(AsyncTask*)petNewsCommentList:(NSString*)pid offset:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager petNewsCommentList:pid offset:offset]];
    task.parser=[[[CommentParser alloc] init] autorelease];
    [task start];

    return task;

}

-(AsyncTask*)createPetNewsComment:(NSString*)pid content:(NSString*)content{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createPetNewsComment]];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:pid forKey:@"id"];
    task.request=request;
    [task start];

    return task;

}

-(AsyncTask*)petNewsDetail:(NSString*)pid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager petNewsDetail:pid]];
    task.parser=[[[PetNewsParser alloc] init] autorelease];
    [task start];

    return task;

}

-(AsyncTask*)likePost:(NSString*)pid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager likePost]];
    [request setPostValue:pid forKey:@"id"];
    task.request=request;
    task.parser=[[[XmlParser alloc] init] autorelease];
    [task start];
    
    return task;

}

-(void)attentionActivaty:(ActivatyModel*)model{
    SqliteLib* sqlite=[[SqliteLib alloc] init];
    [sqlite open:[PathUtils localDBSqlite]];
    [sqlite execute:[NSString stringWithFormat:@"delete from favior_activaty where id=\"%@\"",model.aid]];
    [sqlite prepare:@"insert into favior_activaty (id,uid,nickname,title,content) values(:id,:uid,:nickname,:title,:content)" ];
    [sqlite bind:model.aid index:0];
    [sqlite bind:model.petUser.uid index:1];
    [sqlite bind:model.petUser.nickname index:2];
    [sqlite bind:model.title index:3];
    [sqlite bind:model.desc index:4];
    [sqlite finalize];
    [sqlite release];

}

-(NSArray*)myAttentionActivaty{
    SqliteLib* sqlite=[[SqliteLib alloc] init];
    [sqlite open:[PathUtils localDBSqlite]];
    [sqlite query:@"select id,uid,nickname,title,content from favior_activaty order by id desc"];
    NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:2];
    while([sqlite next]){
        ActivatyModel* model=[[ActivatyModel alloc] init];
        PetUser* petUser=[[PetUser alloc] init];
        model.petUser=petUser;
        [petUser release];
        
        model.aid=[sqlite stringValue:0];
        model.petUser.uid=[sqlite stringValue:1];
        model.petUser.nickname=[sqlite stringValue:2];
        model.title=[sqlite stringValue:3];
        model.desc=[sqlite stringValue:4];
        [array addObject:model];
        [model release];
    }
    [sqlite release];
    
    return [array autorelease];
}

-(AsyncTask*)createActivity:(NSString*)title content:(NSString*)content images:(NSString*)images
                 start_date:(NSDate*)start_date end_date:(NSDate*)end_date join_date:(NSDate*)join_date{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createActivity]];

    [request setPostValue:title forKey:@"title"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:images forKey:@"images"];
    [request setPostValue:start_date forKey:@"start_date"];
    [request setPostValue:end_date forKey:@"end_date"];
    [request setPostValue:join_date forKey:@"join_date"];

    task.request=request;
    task.parser=[[[XmlParser alloc] init] autorelease];
    [task start];
    
    return task;

}

-(AsyncTask*)joinActivity:(NSString*)aid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager joinActivity]];
    
    [request setPostValue:aid forKey:@"id"];
    
    task.request=request;
    task.parser=[[[XmlParser alloc] init] autorelease];
    [task start];
    
    return task;
}

-(AsyncTask*)createActivityComment:(NSString*)aid content:(NSString*)content{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager createActivityComment]];
    
    [request setPostValue:aid forKey:@"id"];
    [request setPostValue:content forKey:@"comment"];

    task.request=request;
    task.parser=[[[XmlParser alloc] init] autorelease];
    [task start];
    
    return task;

}

-(AsyncTask*)activityList:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager activityList:offset]];
    task.parser=[[[ActivatyParser alloc] init] autorelease];
    [task start];
    return task;
}

-(AsyncTask*)activtyDetail:(NSString*)aid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager activtyDetail:aid]];
    task.parser=[[[ActivatyParser alloc] init] autorelease];
    [task start];
    return task;
}

-(AsyncTask*)activtyCommentList:(NSString*)aid offset:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager activtyCommentList:aid offset:offset]];
    task.parser=[[[CommentParser alloc] init] autorelease];
    [task start];
    return task;
}

-(AsyncTask*)myJoinActivaty:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager myJoinActivaty:[DataCenter sharedInstance].user.token offset:offset]];
    task.parser=[[[ActivatyParser alloc] init] autorelease];
    [task start];

    return task;
}

-(AsyncTask*)petNewsListByUser:(NSString*)uid offset:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager petNewsListByUser:uid token:[DataCenter sharedInstance].user.token offset:offset]];
    task.parser=[[[PetNewsParser alloc] init] autorelease];
    [task start];
    return task;

}


-(AsyncTask*)deletePost:(NSString*)pid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager deletePost]];
    
    [request setPostValue:pid forKey:@"id"];
    
    task.request=request;
    [task start];
    return task;

}

-(AsyncTask*)deleteActivity:(NSString*)aid{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.parser=[[[XmlParser alloc] init] autorelease];
    FormDataRequest* request=[FormDataRequest requestWithURL:[ApiManager deleteActivity]];
    
    [request setPostValue:aid forKey:@"id"];
    
    task.request=request;
    [task start];
    return task;
}

-(AsyncTask*)emailMessage:(int)offset{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager emailMessage:[DataCenter sharedInstance].user.token offset:offset]];
    task.parser=[[[MessageParser alloc] init] autorelease];
    [task start];
    return task;
    

}


-(AsyncTask*)summary{
    AsyncTask* task=[[[AsyncTask alloc] init] autorelease];
    task.request=[HTTPRequest requestWithURL:[ApiManager summary:[DataCenter sharedInstance].user.token]];
    task.parser=[[[MessageParser alloc] init] autorelease];
    [task start];
    return task;

}

@end
