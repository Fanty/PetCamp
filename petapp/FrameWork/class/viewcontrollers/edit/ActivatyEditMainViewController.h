//
//  ActivatyEditMainViewController.h
//  PetNews
//
//  Created by fanty on 13-8-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"

@class AsyncTask;
@class ImageUploaded;
@class MBProgressHUD;
@interface ActivatyEditMainViewController : BaseViewController{
    UITableView* tableView;
    
    ImageUploaded* imageUploaded;
    
    AsyncTask* task;
    
    MBProgressHUD* loadingHud;
    
    int imageQueue;
    
    NSMutableString* imageLinks;
    
}

@end
