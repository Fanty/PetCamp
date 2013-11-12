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
    
    UIButton* fliterBg;

    HeadTabView* headTab;
    
    ContactTableView* contactTableView;
    GroupTableView* groupTableView;
}

@end
