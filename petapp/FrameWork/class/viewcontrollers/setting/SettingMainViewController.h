//
//  SettingMainViewController.h
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class UserProfileView;
@interface SettingMainViewController : NavContentViewController{
    UserProfileView* profileView;
    UITableView* tableView;

}

@end
