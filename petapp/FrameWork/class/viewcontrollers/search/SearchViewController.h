//
//  SearchViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"

#define SEARCH_NORMAL_WIDTH  270


@interface SearchViewController : BaseViewController{
    UISearchBar* searchBar;
    
    UIView*  filterView;
}

-(void)filterValue:(float)value;

-(void)searchBarResignFirstResponder;

@end
