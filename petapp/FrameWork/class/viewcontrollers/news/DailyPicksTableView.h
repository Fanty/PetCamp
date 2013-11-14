//
//  DailyPicksTableView.h
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@class AsyncTask;
@class ImageViewer;
@class PetNewsViewController;

@interface DailyPicksTableView : PullTableView{
    
    ImageViewer* carouselBanner;
    
    NSMutableArray* list;
    AsyncTask* task;

}
@property(assign,nonatomic) PetNewsViewController* parentViewController;

-(void)clear;
-(void)updateBanner;

@end
