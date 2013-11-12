//
//  UILabel+theme.m
//  GTGZLibrary
//
//  Created by fanty on 13-4-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UILabel+theme.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation UILabel(theme)

-(void)theme:(NSString*)key{
    GTGZTheme* theme=[[GTGZThemeManager sharedInstance] get:key];
    if(theme!=nil){
        if(theme.backgroundColor!=nil)
            self.backgroundColor=theme.backgroundColor;
        else
            self.backgroundColor=[UIColor clearColor];
        if(theme.textColor!=nil)
            self.textColor=theme.textColor;
        if(theme.highlightColor!=nil)
            self.highlightedTextColor=theme.highlightColor;
        if(theme.fontSize>0){
            if([Utils isIPad]){
                theme.fontSize+=10.0f;
            }
            self.font=[theme font];
            if([Utils isIPad]){
                theme.fontSize-=10.0f;
            }

        }
        
        
    }
}

@end
