//
//  SplashViewController.m
//  PetNews
//
//  Created by fanty on 13-8-21.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SplashViewController.h"
#import "GTGZThemeManager.h"
#import "AppDelegate.h"
@interface SplashViewController ()
@end

@implementation SplashViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"splash.png"];
    UIImageView* imagView=[[UIImageView alloc] initWithImage:img];

    imagView.frame=self.view.bounds;
    [self.view addSubview:imagView];
    
    [imagView release];
    [[AppDelegate appDelegate] performSelector:@selector(redirectRootPage) withObject:nil afterDelay:1.5f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
