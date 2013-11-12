//
//  UIView+theme.m
//  GTGZLibrary
//
//  Created by fanty on 13-4-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UIView+theme.h"
#import "GTGZThemeManager.h"

@implementation UIView(theme)

-(void)theme:(NSString*)key{
    GTGZTheme* theme=[[GTGZThemeManager sharedInstance] get:key];
    if(theme!=nil){
        if(theme.backgroundColor!=nil)
            self.backgroundColor=theme.backgroundColor;
        else
            self.backgroundColor=[UIColor clearColor];
    }
}

@end
