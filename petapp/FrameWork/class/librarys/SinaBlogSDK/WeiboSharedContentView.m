//
//  WeiboSharedContentView.m
//  PetNews
//
//  Created by fanty on 13-9-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WeiboSharedContentView.h"
#import "WeiboRequest.h"
#import "AlertUtils.h"
@interface WeiboSharedContentView()<WeiboRequestDelegate>
-(void)cancel;
-(void)send;
@end

@implementation WeiboSharedContentView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        bar.backgroundColor=[UIColor redColor];
        bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:bar];
        [bar release];
        UINavigationItem *navItem = [[[UINavigationItem alloc]initWithTitle:@"请输入分享内容"] autorelease];
        navItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]autorelease];
        
        navItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(send)]autorelease];

        [bar pushNavigationItem:navItem animated:NO];
        
        CGRect rect=self.bounds;
        rect.origin.y=CGRectGetMaxY(bar.frame);
        rect.size.height-=rect.origin.y;
        textView=[[UITextView alloc] initWithFrame:rect];
        
        textView.returnKeyType = UIReturnKeyDefault; //just as an example
        textView.font = [UIFont systemFontOfSize:18.0f];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor=[UIColor blackColor];
        [self addSubview:textView];
        [textView release];

        request = [[WeiboRequest alloc] initWithDelegate:self];


        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];

        
    }
    return self;
}

-(void)dealloc{
    [request release];
    [super dealloc];
}

-(void)sharedContent:(NSString*)content{
    textView.text=content;
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    
    
    CGRect textViewFrame=textView.frame;
    
    
    textViewFrame.size.height=self.bounds.size.height-keyboardBounds.size.height-CGRectGetMaxY(bar.frame);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];
}

-(void)setContent:(NSString*)content{
    textView.text=content;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}



-(void)show{
    
    CGRect rect=self.frame;
    rect.origin.y=rect.size.height;
    self.frame=rect;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.frame;
        rect.origin.y=0.0f;
        self.frame=rect;
        
    } completion:^(BOOL finish){
        [textView becomeFirstResponder];
    }];
}


-(void)cancel{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.frame;
        rect.origin.y=self.superview.frame.size.height;
        self.frame=rect;
        
    } completion:^(BOOL finish){
        [self removeFromSuperview];
        
    }];
    
}

-(void)send{
    if([textView.text length]<1){
        return;
    }
        
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *postPath = @"statuses/update.json";
    [params setObject:textView.text forKey:@"status"];
    [request postToPath:postPath params:params];

    
}

- (void)request:(WeiboRequest *)request didFailWithError:(NSError *)error {

    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"新浪微博" message:@"分享失败" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)request:(WeiboRequest *)request didLoad:(id)result {
    [self cancel];
}


@end
