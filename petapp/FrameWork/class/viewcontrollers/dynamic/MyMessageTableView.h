//
//  MyMessageTableView.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@class AsyncTask;
@class UserProfileView;

@interface MyMessageTableView : PullTableView{
    UIImageView*  bgView;
    UserProfileView* profileView;

    NSMutableArray* list;
    AsyncTask* task;
    int pageOffset;
}


@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

@end
