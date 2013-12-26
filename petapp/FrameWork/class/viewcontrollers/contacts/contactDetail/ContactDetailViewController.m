//
//  ContactDetailViewController.m
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "PetUser.h"
#import "PetNewsModel.h"
#import "PullTableView.h"
#import "UserProfileView.h"
#import "PetCell.h"
#import "GTGZThemeManager.h"
#import "AsyncTask.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "PetNewsAndActivatyManager.h"
#import "PetNewsEditViewController.h"
#import "PetNewsNavigationController.h"
#import "PetNewsDetailViewController.h"
#import "MBProgressHUD.h"
#import "AlertUtils.h"
#import "WriterView.h"
#import "GTGZUtils.h"

@interface ContactDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate,UserProfileViewDelegate,WriterViewDelegate>
-(void)initHeader;
-(void)initTable;
-(void)loadDetailData;
-(void)loadPetNewsList;
-(void)retryClick;
-(void)doSendMessage:(NSString*)content;
@end

@implementation ContactDetailViewController
@synthesize uid;

-(id)init{
    self=[super init];
    
    [self backNavBar];
    self.navigationItem.rightBarButtonItem=nil;
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    offset=0;
    [self initLoading];
    
    [self loadDetailData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [task cancel];
    task=nil;
    [list release];
    list=nil;
    [petUser release];
    petUser=nil;
    [profileView release];
    profileView=nil;

    [writerView close];
    [writerView release];
    writerView=nil;
}

-(void)dealloc{
    [profileView release];

    [petUser release];
    [task cancel];
    self.uid=nil;
    [list release];
    
    [writerView close];
    [writerView release];

    
    [super dealloc];
}


#pragma mark method

-(void)initLoading{
    loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.frame=CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
    loadingView.center=self.view.center;
    [self.view addSubview:loadingView];
    [loadingView release];
}

-(void)initTable{
    tableView=[[PullTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.scrollsToTop=YES;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.touchDelegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [tableView release];
    [tableView createLoadMoreFooter];
    tableView.loadMoreState=PullTableViewLoadMoreStateDragLoading;
}

-(void)initHeader{
    if(profileView!=nil)return;

    
    profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.0f)];
    profileView.delegate=self;
    [profileView headUrl:petUser.imageHeadUrl];
    [profileView title:petUser.nickname];
    [profileView desc:petUser.person_desc];
    [profileView sex:petUser.sex];
    [profileView isContact:petUser.whetherInContact];
}

-(void)loadDetailData{
    [petUser release];
    petUser=nil;
    [loadingView startAnimating];
    [noLabelButton removeFromSuperview];
    noLabelButton=nil;
    [task cancel];
    task=[[AppDelegate appDelegate].contactGroupManager userDetail:self.uid];
    [task setFinishBlock:^{
        [loadingView stopAnimating];
        NSArray* __list=[task result];
        task=nil;
        if([__list count]<1){
            if(noLabelButton==nil){
                noLabelButton=[UIButton buttonWithType:UIButtonTypeCustom];
                noLabelButton.backgroundColor=[UIColor clearColor];
                [noLabelButton setTitle:lang(@"reNoLabelClick") forState:UIControlStateNormal];
                [noLabelButton theme:@"reNoLabelClick"];
                noLabelButton.frame=self.view.bounds;
                [noLabelButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:noLabelButton];
            }
            [self.view bringSubviewToFront:noLabelButton];
            
        }
        else{
            petUser=[[__list objectAtIndex:0] retain];
            [loadingView stopAnimating];
            [loadingView removeFromSuperview];
            loadingView=nil;
            
            [self initTable];
            [self loadPetNewsList];
        }
    
    }];
}


-(void)loadPetNewsList{
    
    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager petNewsListByUser:self.uid offset:offset];
    [task setFinishBlock:^{
        tableView.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task error]!=nil){
            
            [tableView releaseLoadMoreFooter];
        }
        else{
            offset++;
            NSArray* array=[task result];
            
            if(list==nil){
                list=[[NSMutableArray alloc] initWithCapacity:2];
            }
            
            if([array count]>0)
                [list addObjectsFromArray:array];
            
            if([array count]<HTTP_PAGE_SIZE){
                [tableView releaseLoadMoreFooter];
            }
            else{
                [tableView createLoadMoreFooter];
            }
            [tableView reloadData];
        }
        task=nil;
        
    }];
}

-(void)retryClick{
    [self loadDetailData];
}

-(void)doSendMessage:(NSString*)content{
    [task cancel];
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
    [hud show:YES];
    task=[[AppDelegate appDelegate].contactGroupManager createBoard:self.uid content:content];
    [task setFinishBlock:^{
        [hud hide:NO];
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            [AlertUtils showAlert:lang(@"write_message_success") view:self.view];
        }
        task=nil;
    }];

}

#pragma mark table delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(task==nil && tableView.dragging && !tableView.decelerating)
        [tableView checkLoadMoreScrollingState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(task==nil && tableView.loadMoreState==PullTableViewLoadMoreStateDragStartLoad){
        tableView.loadMoreState=PullTableViewLoadMoreStateDragLoading;
        [self loadPetNewsList];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(task==nil &&  tableView.loadMoreState==PullTableViewLoadMoreStateDragUp){
        tableView.loadMoreState=PullTableViewLoadMoreStateDragStartLoad;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [list count]+1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self initHeader];
    if([indexPath row]==0){
        return CGRectGetMaxY(profileView.frame);
    }
    else{
        return [PetCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [self initHeader];
        }

        [cell addSubview:profileView];
        
        return cell;
    }
    else{
        
        PetCell *cell = (PetCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[PetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            
        }
        
        
        PetNewsModel* model=[list objectAtIndex:[indexPath row]-1];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell nickName:model.petUser.nickname];
        [cell content:model.desc];
        [cell like:model.laudCount comment:model.command_count];
        [cell createDate:model.createdate];
        [cell images:model.imageUrls];

        return cell;
    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath row]>0){
        PetNewsModel* model=[list objectAtIndex:[indexPath row]-1];
        PetNewsDetailViewController* controller=[[PetNewsDetailViewController alloc] init];
        controller.pid=model.pid;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark  userprofile delegate

-(void)profileDidSendPetNews:(UserProfileView *)profileView{
    PetNewsEditViewController* controller=[[PetNewsEditViewController alloc] init];
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
    
}

-(void)profileDidAddFriend:(UserProfileView *)profileView{

    if(petUser.whetherInContact){
        if(writerView==nil){
            writerView=[[WriterView alloc] init];
            writerView.delegate=self;
        }
        [writerView buttonText:lang(@"message")];
        [writerView placeholder:lang(@"write_message")];
        
        [writerView show];

        return;
    }
    
    [task cancel];
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
    [hud show:YES];
    task=[[AppDelegate appDelegate].contactGroupManager makeFriend:self.uid];
    [task setFinishBlock:^{
        [hud hide:NO];
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            [[AppDelegate appDelegate].contactGroupManager sync];
            [AlertUtils showAlert:lang(@"addfriendSuccess") view:self.view];
            petUser.whetherInContact=YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendUpdateNotification object:nil];
        }
        task=nil;
    }];
    
}


#pragma mark  writerview delegate

-(void)didPostInWriterView:(WriterView*)_writerView{
    NSString* content=[GTGZUtils trim:writerView.text];
    if([content length]>0){
        [self doSendMessage:content];
    }
    
    [writerView close];
    [writerView release];
    writerView=nil;
}

-(void)didCancelInWriterView:(WriterView*)_writerView{
    
}



@end
