//
//  FooterMore.m
//  PetNews
//
//  Created by fanty on 13-1-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "FooterMore.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@implementation FooterMore

@synthesize themeKey;

- (id)initWithFrame:(CGRect)frame{
    frame.size.height=([Utils isIPad]?90.0f:45.0f);
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        
        arrowView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"icon_show_more.png"]];
        
        arrowView.transform=CGAffineTransformMakeRotation(M_PI/180 *180);
        [self addSubview:arrowView];
        [arrowView release];
        
        moreLabel=[[UILabel alloc] initWithFrame:self.bounds];
        moreLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:moreLabel];
        [moreLabel release];
        
        
        loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingView.color=[UIColor blackColor];
        float size=([Utils isIPad]?32.0f:16.0f);
        loadingView.frame=CGRectMake(0.0f,0.0f, size, size);
        [self addSubview:loadingView];
        [loadingView release];
        
        [moreLabel theme:@"more_theme"];
    }
    return self;
}

-(void)dealloc{
    [loadingView stopAnimating];
    self.themeKey=nil;
    [super dealloc];
}

-(void)sizeToFit{
    moreLabel.frame=self.bounds;
    [moreLabel sizeToFit];
    
    if([self loading]){
        float left=floor((self.bounds.size.width-(loadingView.frame.size.width+([Utils isIPad]?20.0f:10.0f)+moreLabel.frame.size.width))*0.5f);
        CGRect rect=loadingView.frame;
        rect.origin.x=left;
        rect.origin.y=(self.bounds.size.height-rect.size.height)*0.5f;
        loadingView.frame=rect;
        left=CGRectGetMaxX(rect)+([Utils isIPad]?20.0f:10.0f);
        
        rect=moreLabel.frame;
        rect.origin.x=left;
        rect.origin.y=(self.bounds.size.height-rect.size.height)*0.5f;
        moreLabel.frame=rect;

    }
    else{
        float left=floor((self.bounds.size.width-(arrowView.frame.size.width+([Utils isIPad]?6.0f:3.0f)+moreLabel.frame.size.width))*0.5f);
        CGRect rect=arrowView.frame;
        rect.origin.x=left;
        rect.origin.y=floor((self.bounds.size.height-rect.size.height)*0.5f);
        arrowView.frame=rect;
        left=CGRectGetMaxX(rect)+([Utils isIPad]?6.0f:3.0f);
        
        rect=moreLabel.frame;
        rect.origin.x=left;
        rect.origin.y=floor((self.bounds.size.height-rect.size.height)*0.5f);
        moreLabel.frame=rect;

    }
    
}


-(void)indicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    loadingView.activityIndicatorViewStyle=style;
}

-(void)text:(NSString*)value{
    moreLabel.text=value;
    [self sizeToFit];
}

-(void)loading:(BOOL)value{
    if(value){
        [loadingView startAnimating];
    }
    else{
        [loadingView stopAnimating];
    }
    arrowView.hidden=value;
    [self sizeToFit];
}

-(BOOL)loading{
    return arrowView.hidden;
}

-(void)arrowChange:(BOOL)down animate:(BOOL)animate{
    if(animate){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
    }
    if(!down){
        arrowView.transform=CGAffineTransformMakeRotation(M_PI/180 *180);
    }
    else{
        arrowView.transform=CGAffineTransformIdentity;
    }
    if(animate){
        [UIView commitAnimations];
    }
}

@end
