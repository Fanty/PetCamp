//
//  RootViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
@interface RootViewController ()
//-(void)panGuesture:(UIPanGestureRecognizer*)recognizer;
-(void)adjustViews:(BOOL)rightToLeft;
@end

@implementation RootViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    /*
    searchViewController=[[SearchViewController alloc] init];
    searchViewController.view.frame=self.view.bounds;
    [self.view addSubview:searchViewController.view];
    */
    
    homeViewController=[[HomeViewController alloc] init];
    homeViewController.view.frame=self.view.bounds;
    [self.view addSubview:homeViewController.view];
    
    [homeViewController loadTabBar];
    
    /*
    UIPanGestureRecognizer* panGestureRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuesture:)];
    [homeViewController.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];

     */
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
    [searchViewController.view removeFromSuperview];
    [searchViewController release];
    searchViewController=nil;
    [homeViewController.view removeFromSuperview];
    [homeViewController release];
    homeViewController=nil;
}

-(void)dealloc{
    [searchViewController.view removeFromSuperview];
    [searchViewController release];
    searchViewController=nil;
    [homeViewController.view removeFromSuperview];
    [homeViewController release];
    homeViewController=nil;

    [super dealloc];
}

#pragma mark method

-(void)adjustViews:(BOOL)rightToLeft{
    CGRect frame=homeViewController.view.frame;
    if(rightToLeft){
        if(frame.origin.x<-190.0f)
            showSarchStatus=ShowSearchStatusNormal;
        else
            showSarchStatus=ShowSearchStatusNone;
    }
    else{
        if(frame.origin.x<-50.0f)
            showSarchStatus=ShowSearchStatusNormal;
        else
            showSarchStatus=ShowSearchStatusNone;
    }
    [UIView beginAnimations:@"root_view_menu_animated" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self showMenurWithNoAnimated:showSarchStatus];
    [UIView commitAnimations];
}

-(void)autoShowMenu{
    if(filterView==nil){
        filterView=[[UIView alloc] init];
        filterView.backgroundColor=[UIColor clearColor];
        filterView.userInteractionEnabled=YES;
        filterView.alpha=0.0f;
        [self.view addSubview:filterView];
        [filterView release];
    }
    [self showMenurWithNoAnimated:showSarchStatus];
    showSarchStatus=(showSarchStatus==ShowSearchStatusNone?ShowSearchStatusNormal:ShowSearchStatusNone);
    
    if(showSarchStatus){
        [searchViewController filterValue:0.8f];
        searchViewController.view.transform=CGAffineTransformMakeScale(0.95f, 0.95f);
    }
    else{
        [searchViewController filterValue:0.0f];
        searchViewController.view.transform=CGAffineTransformIdentity;
    }
    
    [UIView beginAnimations:@"root_view_menu_animated" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self showMenurWithNoAnimated:showSarchStatus];
    
    [UIView commitAnimations];
}


-(void)showMenurWithNoAnimated:(ShowSearchStatus)show{
    showSarchStatus=show;
    [filterView removeFromSuperview];
    filterView=nil;
    if(filterView==nil && showSarchStatus!=ShowSearchStatusNone){
        filterView=[[UIView alloc] init];
        filterView.backgroundColor=[UIColor clearColor];
        filterView.userInteractionEnabled=YES;
        filterView.alpha=0.0f;
        [self.view addSubview:filterView];
        [filterView release];
    }
    
    CGRect frame=homeViewController.view.frame;
    frame.origin.x=(showSarchStatus!=ShowSearchStatusNone?-SEARCH_NORMAL_WIDTH:0);
    homeViewController.view.frame=frame;
    if(showSarchStatus!=ShowSearchStatusNone){
        frame.origin.y+=50.0f;
        filterView.frame=frame;
        filterView.alpha=1.0f;
        [searchViewController filterValue:0.0f];
        searchViewController.view.transform=CGAffineTransformIdentity;        
    }
    else{
        [searchViewController filterValue:0.8f];
    }
}

-(void)showFullSearchPage{
    showSarchStatus=ShowSearchStatusAll;
    [UIView beginAnimations:@"root_view_menu_animated" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    
    CGRect frame=homeViewController.view.frame;
    frame.origin.x=-frame.size.width;
    homeViewController.view.frame=frame;
    
    frame.origin.y+=50.0f;
    filterView.frame=frame;


    [UIView commitAnimations];

}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [searchViewController searchBarResignFirstResponder];
    
    UITouch* touch=[touches anyObject];
    lastestPoint=[touch locationInView:self.view];
    if(CGRectContainsPoint(filterView.frame, lastestPoint)){
        isTouch=YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isTouch ){
        UITouch* touch=[touches anyObject];
        CGPoint point=[touch locationInView:self.view];
        float x=point.x-lastestPoint.x;
        lastestPoint=point;
        
        CGRect frame=homeViewController.view.frame;
        frame.origin.x+=x;
        if(frame.origin.x>0)
            frame.origin.x=0;
        
        if(frame.origin.x<-SEARCH_NORMAL_WIDTH)
            frame.origin.x=-SEARCH_NORMAL_WIDTH;
        
        homeViewController.view.frame=frame;
        
        frame=filterView.frame;
        frame.origin.x=homeViewController.view.frame.origin.x;
        filterView.frame=frame;
        
        float offset=-frame.origin.x/SEARCH_NORMAL_WIDTH*0.8f;
        float scale=-frame.origin.x/SEARCH_NORMAL_WIDTH *0.05f+0.95f;
        [searchViewController filterValue:1-offset];
        searchViewController.view.transform=CGAffineTransformMakeScale(scale, scale);
        
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isTouch){
        isTouch=NO;
        [self adjustViews:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isTouch){
        isTouch=NO;
        [self adjustViews:YES];
    }
}


-(void)panGuesture:(UIPanGestureRecognizer*)recognizer{
    if(showSarchStatus!=ShowSearchStatusNone)return;

    switch (recognizer.state){
        case UIGestureRecognizerStateBegan:{
            lastestPoint=[recognizer translationInView:self.view];
            isTouch=YES;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            if(isTouch){
                isTouch=NO;
                [self adjustViews:NO];
            }
            
            break;
        }
        default:{
            
            if(isTouch ){
                CGPoint point=[recognizer translationInView:self.view];
                float x=point.x-lastestPoint.x;
                lastestPoint=point;
                
                CGRect frame=homeViewController.view.frame;
                frame.origin.x+=x;
                if(frame.origin.x>0)
                    frame.origin.x=0;
                
                if(frame.origin.x<-SEARCH_NORMAL_WIDTH)
                    frame.origin.x=-SEARCH_NORMAL_WIDTH;
                
                homeViewController.view.frame=frame;
                
                frame=filterView.frame;
                frame.origin.x=homeViewController.view.frame.origin.x;
                filterView.frame=frame;
                
                float offset=-frame.origin.x/SEARCH_NORMAL_WIDTH*0.8f;
                float scale=-frame.origin.x/SEARCH_NORMAL_WIDTH *0.05f+0.95f;
                [searchViewController filterValue:1-offset];
                searchViewController.view.transform=CGAffineTransformMakeScale(scale, scale);
                
            }
            
        }
    }
    
}
*/


@end
