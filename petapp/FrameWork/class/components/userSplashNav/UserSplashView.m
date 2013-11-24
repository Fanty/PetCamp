//
//  UserSplashView.m
//  PetNews
//
//  Created by Fanty on 13-11-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "UserSplashView.h"
#import "GTGZThemeManager.h"

@interface UserSplashView()<UIScrollViewDelegate>
-(void)touchTap;
@end

@implementation UserSplashView{
    
    BOOL showEnd;
}

@synthesize touchDelegate;

- (id)initWithFrame:(CGRect)frame{
    frame.size.height-=20.0f;
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:self.bounds];
        imgView.image=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"splash_nav1.png"];
        [self addSubview:imgView];
        [imgView release];
        
        
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0.0f, self.bounds.size.width, self.bounds.size.height)];
        imgView.image=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"splash_nav2.png"];
        [self addSubview:imgView];
        [imgView release];
        
        self.contentSize=CGSizeMake(self.bounds.size.width*2.0f, self.bounds.size.height);
        self.pagingEnabled=YES;
        self.delegate=self;
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        
        UITapGestureRecognizer* recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap)];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
        
    }
    return self;
}

-(void)touchTap{
    if(showEnd){
        if([self.touchDelegate respondsToSelector:@selector(didSplashEnd:)])
            [self.touchDelegate didSplashEnd:self];
    }
    else{
        self.userInteractionEnabled=NO;
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self setContentOffset:CGPointMake(self.frame.size.width, 0.0f)];
        
        } completion:^(BOOL finish){
    
            self.userInteractionEnabled=YES;
            showEnd=YES;
        }];
    }
}

#pragma mark scrollview delegate


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if(!showEnd)
            showEnd=scrollView.contentOffset.x>0.0f;
        else{
            if(scrollView.contentOffset.x>0.0f){
                if([self.touchDelegate respondsToSelector:@selector(didSplashEnd:)])
                    [self.touchDelegate didSplashEnd:self];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(!showEnd)
        showEnd=scrollView.contentOffset.x>0.0f;
    else{
        if(scrollView.contentOffset.x>0.0f){
            if([self.touchDelegate respondsToSelector:@selector(didSplashEnd:)])
                [self.touchDelegate didSplashEnd:self];
        }
    }
}

@end
