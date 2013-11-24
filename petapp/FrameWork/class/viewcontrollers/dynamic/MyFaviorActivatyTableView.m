//
//  MyFaviorActivatyTableView.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyFaviorActivatyTableView.h"

#import "PullToRefresh.h"
#import "ActivatyModel.h"
#import "PetUser.h"
#import "ActivatyCell.h"
#import "ActivityDetailViewController.h"
#import "AppDelegate.h"
#import "PetNewsAndActivatyManager.h"

#import "GTGZThemeManager.h"
#import "DataCenter.h"

#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "Utils.h"


@interface MyFaviorActivatyTableView()<UITableViewDataSource,UITableViewDelegate>
-(void)loadData;
-(void)updateNotification;
@end

@implementation MyFaviorActivatyTableView
@synthesize parentViewController;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [self loadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification) name:FaviorUpdateNotificaton object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [list release];

    [super dealloc];
}


#pragma mark table delegate


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ActivatyCell height];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        ActivatyCell *cell = (ActivatyCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ActivatyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        ActivatyModel* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell title:model.petUser.nickname];
        [cell desc:model.title];
        
        
        return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        ActivatyModel* model=[list objectAtIndex:[indexPath row]];
        
        ActivityDetailViewController* controller=[[ActivityDetailViewController alloc] init];
        controller.aid=model.aid;
        controller.contentTitle=model.title;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
}

#pragma mark method

-(void)loadData{
    [list release];
    list=[[[AppDelegate appDelegate].petNewsAndActivatyManager myAttentionActivaty] retain];
    
    [noLabel removeFromSuperview];
    noLabel=nil;
    if([list count]<1){
        if(noLabel==nil){
            noLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?100.0f:40.0f), self.frame.size.width, self.frame.size.height)];
            [self addSubview:noLabel];
            [noLabel theme:@"noLael"];
            noLabel.text=lang(@"noMyAttention");
            noLabel.textAlignment=NSTextAlignmentCenter;
            [noLabel release];
        }
    }
}

-(void)updateNotification{
    [self loadData];
    [self reloadData];
}

@end
