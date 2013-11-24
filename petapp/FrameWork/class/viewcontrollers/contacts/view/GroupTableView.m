//
//  GroupTableView.m
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupTableView.h"
#import "ContactGroupCell.h"
#import "PetUser.h"
#import "GroupModel.h"
#import "ChatMainViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "DataCenter.h"
#import "AlertUtils.h"
#import "NoCell.h"

@interface GroupTableView()<UITableViewDataSource,UITableViewDelegate>
-(void)notificationUpdate;

@property(nonatomic,retain)     NSString* searchText;
@end

@implementation GroupTableView
@synthesize parentViewController;
@synthesize searchText;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUpdate) name:FriendUpdateNotification object:nil];
        showList=[[NSMutableArray alloc] initWithCapacity:2];

        [self search:nil];
        
    }
    return self;
}

-(void)dealloc{
    self.searchText=nil;
    [showList release];
    [super dealloc];
}

-(void)search:(NSString*)title{
    self.searchText=title;
    [showList removeAllObjects];
    NSArray* list=[DataCenter sharedInstance].groupList;
    for(GroupModel* model in list){
        if([title length]<1 || [model.groupName rangeOfString:title].length>0){
            [showList addObject:model];
        }
    }
    [self reloadData];
}

#pragma mark table delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[DataCenter sharedInstance].groupList count]<1)
        return 1;
    else
        return [showList count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[DataCenter sharedInstance].groupList count]<1){
        return 44.0f;
    }
    else{
        return [ContactGroupCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* list=[DataCenter sharedInstance].groupList;
    if([list count]<1){
        NoCell *cell = (NoCell*)[_tableView dequeueReusableCellWithIdentifier:@"nocell"];
        if(cell == nil){
            cell = [[[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nocell"] autorelease];
        }
        [cell showLoading:[AppDelegate appDelegate].contactGroupManager.syncingGroup];
        return cell;
    }
    else{
        ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        
        GroupModel* model=[showList objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell name:model.groupName];
        [cell desc:[NSString stringWithFormat:lang(@"group_count"),model.user_count]];
        return cell;
    }

}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray* list=[DataCenter sharedInstance].groupList;

    if([list count]<1){

        if(![AppDelegate appDelegate].contactGroupManager.syncingGroup){
            
            NoCell *cell=(NoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            [cell showLoading:YES];
            [[AppDelegate appDelegate].contactGroupManager sync];
        }
    }
    else{
        GroupModel* model=[showList objectAtIndex:[indexPath row]];
        
        ChatMainViewController* controller=[[ChatMainViewController alloc] init];
        controller.groupModel=model;
        controller.title=model.groupName;
        [parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
}


#pragma mark method

-(void)notificationUpdate{
    [self search:self.searchText];
}

@end
