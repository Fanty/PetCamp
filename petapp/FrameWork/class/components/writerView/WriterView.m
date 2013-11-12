//
//  WriterView.m
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WriterView.h"

#import "GTGZThemeManager.h"
#import "ScrollTextView.h"
#import "Utils.h"

#define MAX_TEXT_INPUT_NUMBER  1500

@interface WriterView()<ScrollTextViewDelegate>
-(void)keyboardWillShow:(NSNotification *)note;
-(void)keyboardWillHide:(NSNotification *)note;
-(void)postClick;
@end

@implementation WriterView
@synthesize delegate;
@synthesize limitMaxNumber;
- (id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled=YES;
        self.limitMaxNumber=MAX_TEXT_INPUT_NUMBER;
        UIWindow* window=[[UIApplication sharedApplication] keyWindow];
        self.frame=CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
        
        bgView=[[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor=[UIColor blackColor];
        [self addSubview:bgView];
        [bgView release];
        
        
        UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"comment_panel.png"];
        img=[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f];
        
        pannelView=[[UIImageView alloc] initWithImage:img];
        
        CGRect rect=pannelView.frame;
        rect.size.width=self.frame.size.width;
        rect.size.height=([Utils isIPad]?80.0f:50.0f);
        pannelView.frame=rect;
        pannelView.userInteractionEnabled=YES;
        [self addSubview:pannelView];
        [pannelView release];
        
        UIImage* postImg=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"btn_cancel.png"];
        
        postButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [postButton addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
        postButton.frame=CGRectMake(rect.size.width-postImg.size.width-10.0f, (rect.size.height-postImg.size.height)*0.5f, postImg.size.width, postImg.size.height);
        [postButton setBackgroundImage:postImg forState:UIControlStateNormal];
        [postButton setBackgroundImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"btn_cancel_disable.png"] forState:UIControlStateDisabled];
        [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [postButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        postButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        
        postButton.enabled=NO;
        UIImage* bgImg=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"field.png"];
        bgImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width*0.5f topCapHeight:bgImg.size.height*0.5f];
        if([Utils isIPad]){
            textBgView=[[UIImageView alloc] initWithFrame:CGRectMake(20.0f, (rect.size.height-55.0f)*0.5f, rect.size.width-40.0f-postImg.size.width-10.0f, 55.0f)];
        }
        else{
            textBgView=[[UIImageView alloc] initWithFrame:CGRectMake(10.0f, (rect.size.height-35.0f)*0.5f, rect.size.width-20.0f-postImg.size.width-10.0f, 35.0f)];
        }
        
        textBgView.image=bgImg;
        textBgView.clipsToBounds=YES;
        textBgView.userInteractionEnabled=YES;
        
        textView=[[ScrollTextView alloc] initWithFrame:CGRectMake(0.0f,0.0f, textBgView.frame.size.width, textBgView.frame.size.height)];
        
        textView.maxNumberOfLines = 3;
        textView.returnKeyType = UIReturnKeyDefault; //just as an example
        textView.font = [UIFont systemFontOfSize:[Utils isIPad]?23.0f:15.0f];
        textView.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue]<5.0f){
            textView.contentInset = UIEdgeInsetsMake(1,0,0,0);
            
            textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5,0,5,0);
        }
        textView.backgroundColor = [UIColor clearColor];

        if([Utils isIPad])
            placeHoldView=[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, textBgView.bounds.size.width-40.0f, textBgView.bounds.size.height)];
        else
            placeHoldView=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, textBgView.bounds.size.width-20.0f, textBgView.bounds.size.height)];
        [placeHoldView theme:@"textview_placeholder"];
        
        
        [textBgView addSubview:textView];
        [textBgView addSubview:placeHoldView];
        [pannelView addSubview:textBgView];
        [pannelView addSubview:postButton];
        
        [textBgView release];
        [placeHoldView release];
        
        [textView release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)buttonText:(NSString*)value{
    [postButton setTitle:value forState:UIControlStateNormal];
    
}


-(void)show{
    UIWindow* window=[[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    bgView.alpha=0.0f;
    
	CGRect containerFrame = pannelView.frame;
    
    containerFrame.origin.y=window.bounds.size.height;
    pannelView.frame=containerFrame;
    
    [textView becomeFirstResponder];
}

-(NSString*)text{
    return textView.text;
}

-(void)text:(NSString*)value{
    textView.text=value;
}

-(void)close{
    
    [textView resignFirstResponder];
}

-(void)postClick{
    if([self.delegate respondsToSelector:@selector(didPostInWriterView:)])
        [self.delegate didPostInWriterView:self];
}

-(void)placeholder:(NSString *)value{
    placeHoldView.text=value;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self close];
    if([self.delegate respondsToSelector:@selector(didCancelInWriterView::)])
        [self.delegate didCancelInWriterView:self];
    
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    UIWindow* window=[[UIApplication sharedApplication] keyWindow];
    
	CGRect containerFrame = pannelView.frame;
    
    containerFrame.origin.y = window.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	pannelView.frame=containerFrame;
    bgView.alpha=0.6f;
    
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
    UIWindow* window=[[UIApplication sharedApplication] keyWindow];
	CGRect containerFrame = pannelView.frame;
    containerFrame.origin.y = window.bounds.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	pannelView.frame=containerFrame;
    bgView.alpha=0.0f;
	
	// commit animations
	[UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:[duration doubleValue]];
}

#pragma mark textView delegate


- (BOOL)growingTextView:(ScrollTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.location>=self.limitMaxNumber)
        return NO;
    return YES;
    
}

- (void)growingTextViewDidBeginEditing:(ScrollTextView *)growingTextView{
    
}


- (void)growingTextView:(ScrollTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<5.0f)
        textView.contentInset = UIEdgeInsetsMake(1.5,0,0,0);
    
    CGRect rect=pannelView.frame;
    rect.size.height-=diff;
    rect.origin.y+=diff;
	pannelView.frame = rect;
    
    CGRect textBgViewFrame=textBgView.frame;
    textBgViewFrame.size.height-=diff;
    textBgViewFrame.origin.y=(rect.size.height-textBgViewFrame.size.height)*0.5f;
    textBgView.frame=textBgViewFrame;
    
    
    rect=postButton.frame;
    rect.origin.y-=diff;
    postButton.frame=rect;
    
}

- (void)growingTextViewDidChange:(ScrollTextView *)growingTextView{
    placeHoldView.hidden=([growingTextView.text length]>0);
    postButton.enabled=([growingTextView.text length]>0);
}

@end
