//
//  AppDelegate.h
//  FrameWork
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class PetUser;

@class SettingManager;
@class AccountManager;
@class PetNewsAndActivatyManager;
@class ContactGroupManager;
@class MarketManager;
@class CLLocationManager;
@class BannerManager;
@class AsyncTask;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CLLocationManager *locationManager;
    AsyncTask* locationLoginTask;
}

@property (nonatomic,retain) UIWindow *window;

@property (nonatomic,readonly) RootViewController* rootViewController;

@property(nonatomic,readonly) SettingManager* settingManager;
@property(nonatomic,readonly) AccountManager* accountManager;
@property(nonatomic,readonly) PetNewsAndActivatyManager* petNewsAndActivatyManager;
@property(nonatomic,readonly) ContactGroupManager* contactGroupManager;
@property(nonatomic,readonly) MarketManager* marketManager;
@property(nonatomic,readonly) BannerManager* bannerManager;

+(AppDelegate*)appDelegate;
-(void)redirectLoginPage:(id)delegate noAnimateToPop:(BOOL)noAnimateToPop;
-(void)redirectRootPage;

@end
