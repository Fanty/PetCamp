//
//  PetNewsViewController.h
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class HeadTabView;

@class PetNewsTableView;
@class DailyPicksTableView;
@class ActivityTableView;

@interface PetNewsViewController : NavContentViewController{
    
    HeadTabView* headTab;
    
    PetNewsTableView* petNewsTableView;
    DailyPicksTableView* dailyPicksTableView;
    ActivityTableView* activityTableView;

    
}

-(void)updateIcon;

@end
