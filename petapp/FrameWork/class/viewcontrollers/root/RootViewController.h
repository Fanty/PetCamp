//
//  RootViewController.h
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"

typedef enum _ShowSearchStatus{
    ShowSearchStatusNone=0,
    ShowSearchStatusNormal=1,
    ShowSearchStatusAll=2,
}ShowSearchStatus;

@class HomeViewController;
@class SearchViewController;

@interface RootViewController : BaseViewController{
    HomeViewController* homeViewController;
    
    SearchViewController* searchViewController;
    
    ShowSearchStatus showSarchStatus;
    BOOL isTouch;
    CGPoint lastestPoint;
    UIView*   filterView;

}

-(void)autoShowMenu;

-(void)showMenurWithNoAnimated:(ShowSearchStatus)show;

-(void)showFullSearchPage;

-(void)reloadHomeController;

@end
