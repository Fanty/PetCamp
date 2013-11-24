//
//  MyActivatyViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class HeadTabView;
@class MyJoinActivatyTableView;
@class MyFaviorActivatyTableView;


@interface MyActivatyViewController : NavContentViewController{
    HeadTabView* headTab;
    
    MyJoinActivatyTableView* myJoinActivatyTableView;
    MyFaviorActivatyTableView* myFaviorActivatyTableView;
}

@end
