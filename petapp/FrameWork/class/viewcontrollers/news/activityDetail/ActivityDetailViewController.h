//
//  ActivityDetailViewController.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class ActivityDetailHeader;
@class iCarousel;
@class PullTableView;
@class ActivatyModel;
@class WriterView;
@class AsyncTask;
@class HeadTabView;
@interface ActivityDetailViewController : NavContentViewController{
    UIActivityIndicatorView* loadingView;
    UIButton* noLabelButton;
    ActivityDetailHeader* headerDetail;
    UIView* bgViewCarousel;
    iCarousel* imagesCarousel;
    PullTableView* tableView;
    HeadTabView* tabView;
    
    
    WriterView* writerView;
    
    
    AsyncTask* task;
    
    NSMutableArray* commands;
    
    ActivatyModel* activatyModel;

    int offset;
}

@property(nonatomic,retain) NSString* aid;
@property(nonatomic,retain) NSString* contentTitle;
@end

