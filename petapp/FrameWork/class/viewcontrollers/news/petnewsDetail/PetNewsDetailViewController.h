//
//  PetNewsDetailViewController.h
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class PetNewsDetailHeader;
@class iCarousel;
@class PullTableView;
@class PetNewsModel;
@class WriterView;
@class AsyncTask;
@class HeadTabView;
@interface PetNewsDetailViewController : NavContentViewController{
    UIActivityIndicatorView* loadingView;
    UIButton* noLabelButton;

    PetNewsDetailHeader* headerDetail;
    UIView* bgViewCarousel;
    iCarousel* imagesCarousel;
    PullTableView* tableView;
    HeadTabView* tabView;
    NSMutableArray* commands;
    
    WriterView* writerView;
    
    
    AsyncTask* task;
    
    
    int offset;
    
    PetNewsModel* petNewsModel;
}

@property(nonatomic,retain) NSString* pid;

@end
