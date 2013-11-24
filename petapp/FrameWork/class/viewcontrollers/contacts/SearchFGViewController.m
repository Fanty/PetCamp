//
//  SearchFGViewController.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SearchFGViewController.h"
#import "ContactGroupCell.h"
#import "MBProgressHUD.h"
#import "AlertUtils.h"
#import "ContactGroupManager.h"
#import "AppDelegate.h"
#import "PullTableView.h"
#import "GroupModel.h"
#import "PetUser.h"
#import "PullToRefresh.h"
#import "MemberListViewController.h"
#import "ContactDetailViewController.h"

@interface SearchFGViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,GTGZTouchScrollerDelegate>
-(void)initSearchBar;
-(void)initTableView;
-(void)filterBlick;
-(void)loadData:(BOOL)loadMore;
@end

@implementation SearchFGViewController

@synthesize isSearchGroup;

- (id)init{
    self=[super init];
    if(self){
        [self backNavBar];
    }
    
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    [self initSearchBar];
    
    [self initTableView];
    
    [self loadData:NO];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [task cancel];
    [list release];
    [super dealloc];
}

#pragma mark method

-(void)initSearchBar{
    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    searchBar.barStyle=UIBarStyleBlackOpaque;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];
    
}

-(void)initTableView{
    tableView=[[PullTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(searchBar.frame)) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.touchDelegate=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView release];
}

-(void)filterBlick{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.0f;
    } completion:^(BOOL finish){
        [fliterBg removeFromSuperview];
        fliterBg=nil;
        [searchBar resignFirstResponder];
        
    }];
}


#pragma mark tableview delegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(task==nil && tableView.dragging && !tableView.decelerating)
        [tableView checkLoadMoreScrollingState];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(task==nil && tableView.loadMoreState==PullTableViewLoadMoreStateDragStartLoad){
        tableView.loadMoreState=PullTableViewLoadMoreStateDragLoading;
        [self loadData:YES];
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
    return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ContactGroupCell height];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    if(self.isSearchGroup){
        GroupModel* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.petUser.imageHeadUrl];
        [cell name:model.groupName];
        [cell desc:[NSString stringWithFormat:lang(@"group_count"),model.user_count]];
        return cell;

    }
    else{
        PetUser* model=[list objectAtIndex:[indexPath row]];
        [cell headUrl:model.imageHeadUrl];
        [cell name:model.nickname];
        [cell desc:model.person_desc];
    }
    return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.isSearchGroup){
        GroupModel* model=[list objectAtIndex:[indexPath row]];
        
        MemberListViewController* controller=[[MemberListViewController alloc] init];
        controller.groupId=model.groupId;
        controller.uid=model.petUser.uid;
        controller.title=model.groupName;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else{
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.nickname;
        controller.uid=model.uid;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
}

#pragma mark searchbar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    //  [searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    if(fliterBg==nil){
        fliterBg=[UIButton buttonWithType:UIButtonTypeCustom];
        [fliterBg addTarget:self action:@selector(filterBlick) forControlEvents:UIControlEventTouchUpInside];
        fliterBg.backgroundColor=[UIColor blackColor];
        fliterBg.frame=CGRectMake(0.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:fliterBg];
    }
    fliterBg.alpha=0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.6f;
    } completion:^(BOOL finish){
    }];
    
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
    [self loadData:NO];    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
}


#pragma mark method

-(void)loadData:(BOOL)loadMore{
    [task cancel];
    int temp_pageOffset=pageOffset;
    
    if(!loadMore){
        NSDate* date = [NSDate date];
        [tableView.pullToRefreshView setLastUpdatedDate:date];
        temp_pageOffset=0;
    }
    else{
        temp_pageOffset++;
        
    }
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
    
	
	[hud show:NO];

    if(self.isSearchGroup){
        task=[[AppDelegate appDelegate].contactGroupManager searchGroup:searchBar.text offset:temp_pageOffset];
    }
    else{
        task=[[AppDelegate appDelegate].contactGroupManager searchUser:searchBar.text offset:temp_pageOffset];
    }
    [task setFinishBlock:^{
        [hud hide:NO];
        [tableView.pullToRefreshView stopAnimating];
        tableView.loadMoreState=PullTableViewLoadMoreStateNone;
        
        if([task result]==nil){
            [tableView releaseLoadMoreFooter];
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
            }
        }
        else{
            pageOffset=temp_pageOffset;
            
            NSArray* array=[task result];
            
            if(list==nil){
                list=[[NSMutableArray alloc] initWithCapacity:2];
            }
            
            if(!loadMore)
                [list removeAllObjects];
            if([array count]>0)
                [list addObjectsFromArray:array];
            
            if([array count]<HTTP_PAGE_SIZE){
                [tableView releaseLoadMoreFooter];
            }
            else{
                [tableView createLoadMoreFooter];
            }
        }
        task=nil;
        [tableView reloadData];
        
    }];
    
}

@end
