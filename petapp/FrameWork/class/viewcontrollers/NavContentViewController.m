//
//  NavContentViewController.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@interface NavContentViewController ()

@end

@implementation NavContentViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect rect=self.view.frame;
    rect.origin.y=0.0f;
    rect.size.height-=(44.0f+44.0f);
    self.view.frame=rect;

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
