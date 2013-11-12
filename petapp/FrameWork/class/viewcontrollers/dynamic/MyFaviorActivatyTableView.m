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
#import "UserProfileView.h"
#import "DataCenter.h"

#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "Utils.h"


@interface MyFaviorActivatyTableView()<UITableViewDataSource,UITableViewDelegate,UserProfileViewDelegate>
-(void)initHeader;
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
    [bgView release];
    [profileView release];

    [super dealloc];
}


#pragma mark table delegate


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count]+1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        [self initHeader];
        return CGRectGetMaxY(profileView.frame);
    }
    else{
        return [ActivatyCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        UITableViewCell* cell=[_tableView dequeueReusableCellWithIdentifier:@"first_cell"];
        if(cell==nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"first_cell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        [self initHeader];
        [cell addSubview:bgView];
        [cell addSubview:profileView];
        return cell;
    }
    else{
        
        ActivatyCell *cell = (ActivatyCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ActivatyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        ActivatyModel* model=[list objectAtIndex:[indexPath row]-1];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell title:model.petUser.nickname];
        [cell desc:model.title];
        
        
        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]>0){
        ActivatyModel* model=[list objectAtIndex:[indexPath row]-1];
        
        ActivityDetailViewController* controller=[[ActivityDetailViewController alloc] init];
        controller.aid=model.aid;
        controller.contentTitle=model.title;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}

#pragma mark  userprofile delegate

-(void)profileDidSendPetNews:(UserProfileView *)profileView{
    PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [[AppDelegate appDelegate].rootViewController presentModalViewController:navController animated:YES];
    
    [navController release];
    
}

#pragma mark method

-(void)initHeader{
    if(bgView!=nil)return;
    bgView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"default_myprofile.png"]];
    bgView.contentMode=UIViewContentModeTop;
    bgView.clipsToBounds=YES;
    CGRect rect=bgView.frame;
    if(![Utils isIPad])
        rect.size.height=180.0f;
    bgView.frame=rect;
    
    profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?bgView.frame.size.height-120.0f:115.0f), self.frame.size.width, 0.0f)];
    profileView.delegate=self;
    [profileView headUrl:[DataCenter sharedInstance].user.imageHeadUrl];
    [profileView title:[DataCenter sharedInstance].user.nickname];
    [profileView desc:[DataCenter sharedInstance].user.person_desc];
    [profileView sex:[DataCenter sharedInstance].user.pet_sex];
    [profileView showAddFriend:NO];
    [profileView showAddPetNew:NO];

  //  if([Utils isIPad])
        [profileView allWhite];

}

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
