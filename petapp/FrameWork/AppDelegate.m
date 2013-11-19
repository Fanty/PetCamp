//
//  AppDelegate.m
//  FrameWork
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "AppDelegate.h"
#import "GTGZThemeManager.h"
#import "GTGZImageDownloadedManager.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "PetUser.h"
#import "PetNewsNavigationController.h"
#import "SplashViewController.h"

#import "SettingManager.h"
#import "AccountManager.h"
#import "PetNewsAndActivatyManager.h"
#import "ContactGroupManager.h"
#import "MarketManager.h"
#import "BannerManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TencentOpenAPI/TencentOAuth.h"

#import "Utils.h"
#import "DataCenter.h"

@interface AppDelegate()<CLLocationManagerDelegate>
-(void)initManager;
-(void)callLoginUpdate;
@end

@implementation AppDelegate

@synthesize window;
@synthesize rootViewController;

@synthesize settingManager;
@synthesize accountManager;
@synthesize petNewsAndActivatyManager;
@synthesize contactGroupManager;
@synthesize marketManager;
@synthesize bannerManager;

+(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc{

    [locationManager stopUpdatingLocation];
    [locationManager release];
    
    [settingManager release];
    [accountManager release];
    [petNewsAndActivatyManager release];
    [contactGroupManager release];
    [marketManager release];
    
    self.window=nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    

    [GTGZThemeManager sharedInstance].supportIPad=[Utils isIPad];
    [[GTGZThemeManager sharedInstance] openTheme:([Utils isIPad]?@"ipad_view_theme.xml":@"view_theme.xml")];

    [self initManager];

    
    [settingManager checkSqliteVersion];
    
    [DataCenter sharedInstance].user=[accountManager restoreAccount];

    
    NSString* imageRoot=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    imageRoot=[imageRoot stringByAppendingPathComponent:@"images"];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imageRoot]){
        [fileManager createDirectoryAtPath:imageRoot withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [GTGZImageDownloadedManager sharedInstance].saveImagePath=imageRoot;


    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
 //   if([Utils isIPad])
        self.window.backgroundColor=[UIColor whiteColor];
 ///   else
  //      self.window.backgroundColor=[UIColor blackColor];

    SplashViewController* splashViewController=[[SplashViewController alloc] init];
    window.rootViewController=splashViewController;
    [splashViewController release];
    

    [self.window makeKeyAndVisible];
    
    
    float latitude=[[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
    float longitude=[[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
    [DataCenter sharedInstance].latitude=latitude;
    [DataCenter sharedInstance].longitude=longitude;
    
    
    [self callLoginUpdate];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application{

    [locationManager startUpdatingLocation];

}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

#pragma mark CLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    //uid  31    phone:3456789   pass:123456
    //uid  32    phone:234567890 pass:123456
    //lat:37.7858
    //long  -122.406
    [locationManager stopUpdatingLocation];
    float latitude=newLocation.coordinate.latitude;
    float longitude=newLocation.coordinate.longitude;
    [DataCenter sharedInstance].latitude=latitude;
    [DataCenter sharedInstance].longitude=longitude;
    
    [[NSUserDefaults standardUserDefaults] setFloat:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self callLoginUpdate];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"location manager error:%@", error);
    
}


#pragma mark  method

-(void)initManager{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.distanceFilter=1000.0f;
    [locationManager startUpdatingLocation];

    
    settingManager=[[SettingManager alloc] init];
    accountManager=[[AccountManager alloc] init];
    petNewsAndActivatyManager=[[PetNewsAndActivatyManager alloc] init];
    contactGroupManager=[[ContactGroupManager alloc] init];
    marketManager=[[MarketManager alloc] init];
    bannerManager=[[BannerManager alloc] init];

}

-(void)callLoginUpdate{
    PetUser* user=[DataCenter sharedInstance].user;
    if(user!=nil){
        
        float latitude=[DataCenter sharedInstance].latitude;
        float longitude=[DataCenter sharedInstance].longitude;

        
        [locationLoginTask cancel];
        if([user.accountType length]<1)
            locationLoginTask=[accountManager login:user.bind_phone password:user.password latitude:latitude longitude:longitude];
        else
            locationLoginTask=[accountManager loginSocial:user.account type:user.accountType latitude:latitude longitude:longitude];
        
        [locationLoginTask setFinishBlock:^{
            if([locationLoginTask result]!=nil){
                PetUser* petUser=[locationLoginTask result];
                NSString* password=[user.password retain];
                petUser.password=password;
                [password release];
                if([user.accountType length]>0){
                    
                    NSString* account=[user.account retain];
                    NSString* type=[user.accountType retain];
                    petUser.account=account;
                    petUser.accountType=type;
                    [account release];
                    [type release];
                }
                else{
                    NSString* phone=[user.bind_phone retain];
                    petUser.bind_phone=phone;
                    [phone release];
                }
                [DataCenter sharedInstance].user=petUser;
                
                locationLoginTask=nil;
                
                [contactGroupManager sync];
            }
        }];
    }

}


-(void)redirectLoginPage:(id)delegate noAnimateToPop:(BOOL)noAnimateToPop{
    LoginViewController* loginViewController=[[LoginViewController alloc] init];
    loginViewController.delegate=delegate;
    loginViewController.noAnimateToPop=noAnimateToPop;
    PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:loginViewController];
    [window.rootViewController presentModalViewController:navController animated:YES];
    [loginViewController release];
    [navController release];

}

-(void)redirectRootPage{
    rootViewController=[[RootViewController alloc] init];
    self.window.rootViewController=rootViewController;
    [rootViewController release];
    [self.window makeKeyAndVisible];

}

@end
