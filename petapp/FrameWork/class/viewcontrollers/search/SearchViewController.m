//
//  SearchViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    

    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width-SEARCH_NORMAL_WIDTH, 0.0f, SEARCH_NORMAL_WIDTH, 44.0f)];
    searchBar.showsCancelButton=YES;
//    searchBar.showsSearchResultsButton=YES;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    filterView=[[UIView alloc] initWithFrame:self.view.bounds];
    filterView.alpha=0.0f;
    filterView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:filterView];
    [filterView release];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [[AppDelegate appDelegate].rootViewController showFullSearchPage];

    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{

        CGRect rect=searchBar.frame;
        rect.origin.x=0.0f;
        rect.size.width=self.view.frame.size.width;

        searchBar.frame=rect;

    } completion:^(BOOL finish){
    
    }];

    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) _searchBar{
    [self searchBarResignFirstResponder];
    [[AppDelegate appDelegate].rootViewController autoShowMenu];
    searchBar.text=nil;
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{

        CGRect rect=searchBar.frame;
        rect.size.width=SEARCH_NORMAL_WIDTH;
        rect.origin.x=self.view.frame.size.width-SEARCH_NORMAL_WIDTH;
        searchBar.frame=rect;

    } completion:^(BOOL finish){
        
    }];

}

#pragma mark  method

-(void)filterValue:(float)value{
    filterView.alpha=value;
}

-(void)searchBarResignFirstResponder{
    if([searchBar isFirstResponder])
        [searchBar resignFirstResponder];
}


@end
