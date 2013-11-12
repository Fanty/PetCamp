//
//  MyJoinActivatyTableView.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@class AsyncTask;
@class UserProfileView;

@interface MyJoinActivatyTableView : PullTableView{
    
    UIImageView*  bgView;
    UserProfileView* profileView;

    NSMutableArray* list;
    AsyncTask* task;
    
    UIButton* noButton;

}

@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

@end
