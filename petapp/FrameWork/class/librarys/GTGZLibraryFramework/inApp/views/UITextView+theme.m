//
//  UITextView+theme.m
//  SVW_STAR
//
//  Created by fanty on 13-7-8.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UITextView+theme.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation UITextView(theme)

-(void)theme:(NSString*)key{
    GTGZTheme* theme=[[GTGZThemeManager sharedInstance] get:key];
    if(theme!=nil){
        if(theme.backgroundColor!=nil)
            self.backgroundColor=theme.backgroundColor;
        else
            self.backgroundColor=[UIColor clearColor];
        if(theme.textColor!=nil)
            self.textColor=theme.textColor;
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
