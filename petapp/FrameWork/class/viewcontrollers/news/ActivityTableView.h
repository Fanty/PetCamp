//
//  ActivityTableView.h
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@class AsyncTask;
@class ImageViewer;
@class PetNewsViewController;

@interface ActivityTableView : PullTableView{
    
    ImageViewer* carouselBanner;
    
    NSMutableArray* list;
    AsyncTask* task;
    
    int pageOffset;

}

@property(assign,nonatomic) PetNewsViewController* parentViewController;

-(void)clear;
-(void)updateBanner;

@end
