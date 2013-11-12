//
//  PersonDynamicViewController.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class ImageDownloadedView;
@class HeadTabView;
@class MyPetNewsTableView;
@class MyJoinActivatyTableView;
@class MyFaviorActivatyTableView;
@class MyMessageTableView;
@interface PersonDynamicViewController : NavContentViewController{
    HeadTabView* headTab;

    MyPetNewsTableView* myPetNewsTableView;
    MyJoinActivatyTableView* myJoinActivatyTableView;
    MyFaviorActivatyTableView* myFaviorActivatyTableView;
    MyMessageTableView* myMessageTableView;

}

@end
