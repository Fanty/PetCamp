//
//  PetNewsNavigationController.m
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsNavigationController.h"

#import "GTGZThemeManager.h"

@interface PetNewsButtonItem ()
@end


@implementation PetNewsButtonItem

@end



@interface PetNewsNavigationController ()<UINavigationControllerDelegate>

@end

@implementation PetNewsNavigationController{
    UIImageView* backgroundImage;
    NSString* bgImage;

}

-(id)initWithRootViewController:(UIViewController*)viewController{
    self=[super initWithRootViewController:viewController];
    if (self) {
        self.delegate=self;
    }
    return self;
    
}

- (id)init{
    self = [super init];
    if (self) {
        self.delegate=self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    if( [[[UIDevice currentDevice] systemVersion] floatValue]<5.0){   //ios 5 以下
        CGRect rect=self.navigationBar.bounds;
        backgroundImage=[[UIImageView alloc] initWithFrame:rect];
        backgroundImage.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"header_nav.png"];
        backgroundImage.backgroundColor=[UIColor clearColor];
        backgroundImage.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
        [self.navigationBar addSubview:backgroundImage];
        [backgroundImage release];
                
    }
    else{
        
        [self.navigationBar setBackgroundImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"header_nav.png"] forBarMetrics:UIBarMetricsDefault];
    }

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}


#pragma mark navigationcontroller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.navigationBar sendSubviewToBack:backgroundImage];
    
    if([viewController respondsToSelector:@selector(willShowViewController)])
        [viewController performSelector:@selector(willShowViewController)];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.navigationBar sendSubviewToBack:backgroundImage];
    if([viewController respondsToSelector:@selector(didShowViewController)])
        [viewController performSelector:@selector(didShowViewController)];
    
}


@end
