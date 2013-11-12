//
//  ContactViewController.m
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactViewController.h"
#import "GTGZThemeManager.h"
#import "HeadTabView.h"
#import "ContactTableView.h"
#import "GroupTableView.h"
#import "PetNewsEditViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "AddFriendSelectViewController.h"
#import "PetNewsNavigationController.h"
@interface ContactViewController ()<HeadTabViewDelegte,UISearchBarDelegate>
-(void)initSearchBar;
-(void)initTabBar;
-(void)initTableView:(int)tab;
-(void)addPeronClick;
-(void)filterBlick;
@end

@implementation ContactViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"contacts");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"pet_contact") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_contact.png"] tag:0] autorelease];        
        [self rightNavBar:@"add_persion_header.png" target:self action:@selector(addPeronClick)];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initSearchBar];
    [self initTabBar];
    
    [self initTableView:0];

}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    contactTableView=nil;
    groupTableView=nil;
}

#pragma mark tabbar delegate

-(void)tabDidSelected:(HeadTabView*)tabView index:(int)index{
    [self initTableView:index];
}

#pragma mark method


-(void)initSearchBar{
    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    searchBar.barStyle=UIBarStyleBlackOpaque;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];
    
}

-(void)initTabBar{
    headTab=[[HeadTabView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width, 0.0f)];
    headTab.delegate=self;
    [headTab setTabNameArray:[NSArray arrayWithObjects:lang(@"contact"),lang(@"group"),nil]];
    [self.view addSubview:headTab];
    [headTab release];
}

-(void)initTableView:(int)tab{
    if((tab==0 && contactTableView.hidden)){
        searchBar.text=nil;
        [contactTableView searchText:@""];
    }
    if(tab==1 && groupTableView.hidden){
        searchBar.text=nil;
        [groupTableView search:@""];
    }
    contactTableView.hidden=YES;
    groupTableView.hidden=YES;
    if(tab==0){
        if(contactTableView==nil){
            contactTableView=[[ContactTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            contactTableView.parentViewController=self;
            [self.view addSubview:contactTableView];
            [contactTableView release];
        }
        contactTableView.hidden=NO;
    }
    else if(tab==1){
        if(groupTableView==nil){
            groupTableView=[[GroupTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            groupTableView.parentViewController=self;
            [self.view addSubview:groupTableView];
            [groupTableView release];
            
        }
        groupTableView.hidden=NO;
    }
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

-(void)addPeronClick{
    AddFriendSelectViewController* controller=[[AddFriendSelectViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [contactTableView searchText:searchText];
    [groupTableView search:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
}


@end
