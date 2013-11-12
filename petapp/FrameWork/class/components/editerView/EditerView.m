//
//  EditerView.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "EditerView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@interface EditerView()
-(void)btnClick:(UIButton*)button;
@end

@implementation EditerView

@synthesize delegate;

- (id)init{
    self = [self initWithImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"tab_bg.png"]];
    if (self) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        float h=self.frame.size.height;

        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"photo.png"];
        camerButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [camerButton setImage:img forState:UIControlStateNormal];
        [camerButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        camerButton.tag=0;
        camerButton.frame=CGRectMake([Utils isIPad]?10.0f:0.0f, 0.0f, img.size.width, h);
        [self addSubview:camerButton];
        
        img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"picture.png"];
        phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [phoneButton setImage:img forState:UIControlStateNormal];
        [phoneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        phoneButton.tag=1;
        phoneButton.frame=CGRectMake(CGRectGetMaxX(camerButton.frame), 0.0f, img.size.width, h);
        [self addSubview:phoneButton];
        

        /*
        img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"email.png"];
        adButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [adButton setImage:img forState:UIControlStateNormal];
        [adButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        adButton.tag=2;
        adButton.frame=CGRectMake(CGRectGetMaxX(phoneButton.frame), 0.0f, img.size.width, h);
        [self addSubview:adButton];

        img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"express.png"];
        faceButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [faceButton setImage:img forState:UIControlStateNormal];
        [faceButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        faceButton.tag=2;
        faceButton.frame=CGRectMake(CGRectGetMaxX(adButton.frame), 0.0f, img.size.width, h);
        [self addSubview:faceButton];

         */
    }
    return self;
}

-(void)btnClick:(UIButton*)button{
    if([self.delegate respondsToSelector:@selector(editerClick:click:)])
        [self.delegate editerClick:self click:button.tag];
}

@end
