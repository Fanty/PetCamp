//
//  PetNewsEditViewController.h
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class ScrollTextView;
@class EditerView;
@class ImageUploaded;
@class ImageDownloadedView;
@class AsyncTask;
@class MBProgressHUD;
@interface PetNewsEditViewController : BaseViewController{
    
    ImageDownloadedView* imageDownloaded;
    UITextView* textView;
    ImageUploaded* imageUploaded;
    EditerView* editerView;
    
    UIView*  fgView;
    MBProgressHUD* loadingHud;

    AsyncTask* task;
    
    int imageQueue;
    
    NSMutableString* imageLinks;
    
    UIPopoverController *popover;


}



@end
