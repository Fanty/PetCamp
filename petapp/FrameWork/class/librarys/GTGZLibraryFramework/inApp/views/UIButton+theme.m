//
//  UIButton+theme.m
//  GTGZLibrary
//
//  Created by fanty on 13-4-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UIButton+theme.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIButton (theme)



-(void)theme:(NSString*)key{
    GTGZTheme* theme=[[GTGZThemeManager sharedInstance] get:key];
    if(theme!=nil){
        if(theme.backgroundColor!=nil){
            [self setBackgroundColor:theme.backgroundColor];
        }
        if(theme.textColor!=nil){
            [self setTitleColor:theme.textColor forState:UIControlStateNormal];
        }
        if(theme.highlightColor!=nil){
            [self setTitleColor:theme.highlightColor forState:UIControlStateHighlighted];
        }
        if(theme.selectedColor!=nil){
            [self setTitleColor:theme.selectedColor forState:UIControlStateSelected];
        }

        if(theme.disabledColor!=nil){
            [self setTitleColor:theme.disabledColor forState:UIControlStateDisabled];
        }
        
        if(theme.fontSize>0){
            if([Utils isIPad]){
                theme.fontSize+=10.0f;
            }
            self.titleLabel.font=[theme font];
            if([Utils isIPad]){
                theme.fontSize-=10.0f;
            }

        }
        
        
    }
    
}

@end
