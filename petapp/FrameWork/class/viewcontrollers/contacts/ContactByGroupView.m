//
//  ContactByGroupView.m
//  PetNews
//
//  Created by apple2310 on 13-9-8.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactByGroupView.h"

#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ContactGroupCell.h"
#import "PetUser.h"
#import "ContactDetailViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AlertUtils.h"
#import "NoCell.h"

@interface ContactByGroupView()<GTGZTouchScrollerDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)retryClick;
-(void)notificationUpdate;
@end

@implementation ContactByGroupView

@synthesize parentViewController;
@synthesize groupId;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        self.touchDelegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addPullToRefreshWithActionHandler:^{
            DLog(@"refresh dataSource");
            [self loadData];
        }];
        [self.pullToRefreshView triggerRefresh:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUpdate) name:GroupUpdateNotification object:nil];

    }
    return self;
}

-(void)dealloc{
    self.groupId=nil;
    [list release];
    [task cancel];
    [super dealloc];
}


#pragma mark table delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([list count]<1 && task==nil)
        return 1;
    else
        return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [ContactGroupCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([list count]<1 && task==nil){
        NoCell *cell = (NoCell*)[_tableView dequeueReusableCellWithIdentifier:@"nocell"];
        if(cell == nil){
            cell = [[[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nocell"] autorelease];
        }
        return cell;
    }
    else{
        ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        
        
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.imageHeadUrl];
        [cell name:model.nickname];
        [cell desc:model.person_desc];
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([list count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.nickname;
        controller.uid=model.uid;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    }
}



#pragma mark method

-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)triggerRefresh{
    [self.pullToRefreshView triggerRefresh:YES];

}

-(void)notificationUpdate{
    [self.pullToRefreshView triggerRefresh:YES];
    
}


-(void)retryClick{
    [self.pullToRefreshView triggerRefresh:YES];
}

-(void)loadData{
    [task cancel];
    
    NSDate* date = [NSDate date];
    [self.pullToRefreshView setLastUpdatedDate:date];
    
    
    task=[[AppDelegate appDelegate].contactGroupManager friendList:self.groupId];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];
        
        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self];
            }
        }
        else{
            [list release];
            list=[[task result] retain];
        }
        task=nil;
        [self reloadData];
        
    }];
    
}

-(NSArray*)contacts{
    return list;
}

@end
