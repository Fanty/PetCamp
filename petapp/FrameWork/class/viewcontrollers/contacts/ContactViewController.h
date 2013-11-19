//
//  ContactViewController.h
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class HeadTabView;
@class ContactTableView;
@class GroupTableView;
@class FansTableView;
@interface ContactViewController : NavContentViewController{
    UISearchBar* searchBar;
    
    HeadTabView* headTab;
    
    ContactTableView* contactTableView;
    FansTableView* fansTableView;
    GroupTableView* groupTableView;
}

@end
