//
//  PetNewsForwardEditViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class EditerView;
@class AsyncTask;
@class MBProgressHUD;
@class ForwarDetailView;
@class PetNewsModel;
@interface PetNewsForwardEditViewController : BaseViewController{
    UITextView* textView;
    ForwarDetailView* forwarDetailView;
    EditerView* editerView;

    UIView*  fgView;
    MBProgressHUD* loadingHud;
    
    AsyncTask* task;
    
}

@property(nonatomic,retain) PetNewsModel* petNewsModel;

@end
