//
//  MyPetNewsTableView.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullTableView.h"

@class AsyncTask;
@class UserProfileView;
@class ProfileTab;
@interface MyPetNewsTableView : PullTableView{
    
    UserProfileView* profileView;
    ProfileTab* profileTab;

    NSMutableArray* list;
    AsyncTask* task;
    
    UIButton* noButton;
    
    int offset;
}

@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;



@end

