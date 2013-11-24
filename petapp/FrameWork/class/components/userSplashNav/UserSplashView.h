//
//  UserSplashView.h
//  PetNews
//
//  Created by Fanty on 13-11-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserSplashView;

@protocol UserSplashViewDelegate <NSObject>

-(void)didSplashEnd:(UserSplashView*)userSplashView;

@end

@interface UserSplashView : UIScrollView
@property(nonatomic,assign) id<UserSplashViewDelegate> touchDelegate;
@end
