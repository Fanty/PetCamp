//
//  HeadTabView.m
//  PetNews
//
//  Created by fanty on 13-8-4.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "HeadTabView.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@interface HeadTabView()
-(void)moveTab:(int)index;
-(void)btnTabClick:(UIButton*)button;
@end

@implementation HeadTabView
@synthesize delegate;
@synthesize hightlightWhenTouch;

- (id)initWithFrame:(CGRect)frame{
    if(frame.size.height<1){
        if([Utils isIPad])
            frame.size.height=65.0f;
        else
            frame.size.height=35.0f;
    }
    self = [super initWithFrame:frame];
    if (self) {
            self.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"headtab_bg_white.png"];
        self.userInteractionEnabled=YES;
        self.clipsToBounds=YES;

        selectedImageView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_on_white.png"]];

        [self addSubview:selectedImageView];
        [selectedImageView release];
        
        
        vlineView1=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:([Utils isIPad]?@"h_line.png":@"h_line_white.png")]];
                
        [self addSubview:vlineView1];
        [vlineView1 release];

        
        vlineView2=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:([Utils isIPad]?@"h_line.png":@"h_line_white.png")]];
        
        CGRect rect=vlineView2.frame;
        rect.origin.y=frame.size.height-rect.size.height;
        vlineView2.frame=rect;
        
        [self addSubview:vlineView2];
        [vlineView2 release];
        
        labelList=[[NSMutableArray alloc] initWithCapacity:2];
        lineList=[[NSMutableArray alloc] initWithCapacity:2];
        iconList=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(void)dealloc{
    [labelList release];
    [lineList release];
    [iconList release];
    [super dealloc];
}

-(void)setHightlightWhenTouch:(BOOL)value{
    hightlightWhenTouch=value;
    if(value){
        if(![Utils isIPad] ){
            self.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"headtab_bg.png"];
            selectedImageView.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_on.png"];
            vlineView1.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"];
            
            vlineView2.image=[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"];

        }
    }
}

-(void)showHighlight:(BOOL)value{
    selectedImageView.hidden=!value;
}

-(void)setTabNameArray:(NSArray*)array{
    [labelList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [lineList makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [iconList makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [labelList removeAllObjects];
    [lineList removeAllObjects];
    [iconList removeAllObjects];
    
    float left=0.0f;
    float width=self.frame.size.width/[array count];
    
    UIImage* lineImg=nil;
    if([Utils isIPad] || self.hightlightWhenTouch)
        lineImg=[[GTGZThemeManager sharedInstance] imageByTheme:@"v_line.png"];
    else
        lineImg=[[GTGZThemeManager sharedInstance] imageByTheme:@"v_line_white.png"];
    int index=0;
    for(NSString* str in array){
        UIButton* label =[UIButton buttonWithType:UIButtonTypeCustom];
        if(self.hightlightWhenTouch)
            [label setBackgroundImage:selectedImageView.image forState:UIControlStateHighlighted];
        [label addTarget:self action:@selector(btnTabClick:) forControlEvents:UIControlEventTouchUpInside];
        label.tag=index;
        
        if([Utils isIPad] || self.hightlightWhenTouch)
            [label theme:@"tabhead_title"];
        else
            [label theme:@"tabhead_title2"];

        label.frame=CGRectMake(left, 0.0f, width, self.frame.size.height);
        [label setTitle:str forState:UIControlStateNormal];
        [self addSubview:label];
        [labelList addObject:label];

        
        if(index<[array count]-1){
            UIImageView* lineView=[[UIImageView alloc] initWithImage:lineImg ];
            CGRect rect=lineView.frame;
            rect.origin.x=left+width-rect.size.width;
            lineView.frame=rect;
            [self addSubview:lineView];
            
            [lineList addObject:lineView];
            [lineView release];
        }
        
        UIImageView* iconView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"newtip.png"]];
        iconView.hidden=YES;
        CGRect rect=iconView.frame;
        rect.origin.x=left+width-rect.size.width*1.5f;
        rect.origin.y=rect.size.height*0.5f;
        iconView.frame=rect;
        [self addSubview:iconView];
        [iconList addObject:iconView];
        [iconView release];
        
        left+=width;
        
        index++;
        
    }
    [self moveTab:0];
}

-(void)moveTab:(int)index{
    if([labelList count]<1)return;
    CGRect rect=selectedImageView.frame;
    float width=self.frame.size.width/[labelList count];
    
    rect.size.width=width;
    rect.size.height=self.frame.size.height-2.0f;
    rect.origin.y=1.0f;
    rect.origin.x=(index*width)+(width-rect.size.width)*0.5f;
    selectedImageView.frame=rect;
}

-(void)showNewTip:(BOOL)show index:(int)index{
    UIImageView* iconView=[iconList objectAtIndex:index];
    iconView.hidden=(!show);
}


-(void)btnTabClick:(UIButton*)button{
    
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [self moveTab:button.tag];

    } completion:^(BOOL finish){
        if([self.delegate respondsToSelector:@selector(tabDidSelected:index:) ])
            [self.delegate tabDidSelected:self index:button.tag];

    }];
}

@end
