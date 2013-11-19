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
#import "FansTableView.h"
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
    [headTab setTabNameArray:[NSArray arrayWithObjects:lang(@"contact"),lang(@"fans"),lang(@"group"),nil]];
    [self.view addSubview:headTab];
    [headTab release];
}

-(void)initTableView:(int)tab{
    if((tab==0 && contactTableView.hidden)){
        searchBar.text=nil;
        [contactTableView searchText:@""];
    }
    if(tab==1 && fansTableView.hidden){
        searchBar.text=nil;
        [fansTableView search:@""];
    }
    if(tab==2 && groupTableView.hidden){
        searchBar.text=nil;
        [groupTableView search:@""];
    }
    
    contactTableView.hidden=YES;
    groupTableView.hidden=YES;
    fansTableView.hidden=YES;
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
        if(fansTableView==nil){
            fansTableView=[[FansTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            fansTableView.parentViewController=self;
            [self.view addSubview:fansTableView];
            [fansTableView release];
            
        }
        fansTableView.hidden=NO;
    }
    else if(tab==2){
        if(groupTableView==nil){
            groupTableView=[[GroupTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(headTab.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(headTab.frame)) style:UITableViewStylePlain];
            groupTableView.parentViewController=self;
            [self.view addSubview:groupTableView];
            [groupTableView release];
            
        }
        groupTableView.hidden=NO;
    }
}

-(void)addPeronClick{
    AddFriendSelectViewController* controller=[[AddFriendSelectViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

#pragma mark searchbar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    //  [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];

    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [contactTableView searchText:searchText];
    [fansTableView search:searchText];
    [groupTableView search:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=nil;
    [searchBar resignFirstResponder];
    
    [contactTableView searchText:nil];
    [fansTableView search:nil];
    [groupTableView search:nil];

}


@end
