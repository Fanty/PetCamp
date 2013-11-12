//
//  WeiBoSettingViewController.h
//  PetNews
//
//  Created by apple2310 on 13-9-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class AsyncTask;
@interface WeiBoSettingViewController : NavContentViewController{
    UITextField* textField;
    
    UILabel* label;
    
    UIButton* confirmButton;
    
    AsyncTask* task;
}

@end
