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
@interface ContactViewController : NavContentViewController{
    UISearchBar* searchBar;
    
    HeadTabView* headTab;
    
    ContactTableView* contactTableView;
    ContactTableView* fansTableView;
    GroupTableView* groupTableView;
}

@end
