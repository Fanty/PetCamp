//
//  SettingMainViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class ImageDownloadedView;
@class AsyncTask;
@interface SettingInfoMainViewController : NavContentViewController{
    
    UITableView* tableView;
    
    UISwitch* onlineSwitch;
    
    NSArray* list;
    
    AsyncTask* onlineTask;
}

@end
