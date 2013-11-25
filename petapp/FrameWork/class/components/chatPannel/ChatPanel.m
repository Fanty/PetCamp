//
//  ChatPanel.m
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import "ChatPanel.h"
#import "GTGZThemeManager.h"
#import "Utils.h"


@interface ChatPanel()<UITextViewDelegate>
-(void) keyboardWillShow:(NSNotification *)note;
-(void) keyboardWillHide:(NSNotification *)note;

-(void)adClick;
@end

@implementation ChatPanel

@synthesize text;
@synthesize superViewHeight;
- (id)init{
    
    
    self = [self initWithImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"chatBgPanel.png"]];
    if (self) {
        
        textViewHeight=([Utils isIPad]?65.0f:44.0f);
        
        CGRect rect=self.frame;
        rect.size.height=([Utils isIPad]?100.0f:55.0f);
        self.frame=rect;
        
        self.limitMaxNumber=200;
        self.userInteractionEnabled=YES;
        
        UIImage* bgImg=[UIImage imageNamed:@"field.png"];
        bgImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width*0.5f topCapHeight:bgImg.size.height*0.5f];
        textBgView=[[UIImageView alloc] initWithImage:bgImg];
        textBgView.clipsToBounds=YES;
        textBgView.userInteractionEnabled=YES;
        
        
        UIImage* adImg=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"chat_add.png"];
        [addButton setImage:adImg forState:UIControlStateNormal];
        addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [addButton addTarget:self action:@selector(adClick) forControlEvents:UIControlEventTouchUpInside];
        [addButton setImage:adImg forState:UIControlStateNormal];
        
        
        rect=addButton.frame;
        rect.origin.x=0.0f;
        rect.origin.y=0.0f;
        rect.size.width=adImg.size.width*1.5f;
        rect.size.height=self.frame.size.height;
        addButton.frame=rect;
        
        rect=textBgView.frame;
        rect.size.height=textViewHeight;

        rect.origin.x=CGRectGetMaxX(addButton.frame)+5.0f;
        rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
        rect.size.width=self.frame.size.width-adImg.size.width*1.5f-10.0f;
        textBgView.frame=rect;
        
        
        textView=[[UITextView alloc] initWithFrame:textBgView.bounds];
        
        textView.delegate=self;
        textView.clipsToBounds=YES;
        textView.font = [UIFont systemFontOfSize:([Utils isIPad ]?28.0f:18.0f)];
        textView.backgroundColor=[UIColor clearColor];
        textView.textColor=[UIColor blackColor];
        textView.returnKeyType=UIReturnKeySend;

        
        [self addSubview:addButton];
        [textBgView addSubview:textView];
        [self addSubview:textBgView];
        [textView release];
        [textBgView release];
        

        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];

        
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(BOOL)resignFirstResponder{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark method


-(void)adClick{
    if([self.delegate respondsToSelector:@selector(chatPanelDidSelectedAdd:)])
        [self.delegate chatPanelDidSelectedAdd:self];
}

-(NSString*)text{
        return textView.text;
}

-(void)setText:(NSString *)value{
    textView.text=value;
    
    [self textViewDidChange:textView];
    
    if(textView.contentSize.height>textViewHeight*3.0f){
        CGPoint point=textView.contentOffset;
        point.y=textView.contentSize.height-textView.frame.size.height;
        [textView setContentOffset:point animated:YES];
    }
    
}


#pragma mark textview delegate



- (BOOL)textView:(UITextView *)__textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)__text{
    
    if ([__text isEqualToString:@"\n"]) {
        
        //[__textView resignFirstResponder];
        
        if([self.delegate respondsToSelector:@selector(chatPanelDidSend:)])
            [self.delegate chatPanelDidSend:self];

        return NO;
	}

    NSString* tempText=[__textView.text stringByReplacingCharactersInRange:range withString:__text];
    if([tempText length]>=self.limitMaxNumber)
        return NO;
    return YES;

}

- (void)textViewDidChange:(UITextView *)__textView{
    float height=__textView.contentSize.height;
    if([__textView.text length]<1){
        height=textBgView.frame.size.height;
    }
    
    if(height>textViewHeight*3.0f)
        height=textViewHeight*3.0f;
    if(currentHeight==0)
        currentHeight=height;
    if(currentHeight!=height){
        float diff=currentHeight-height;
        currentHeight=height;
        
        CGRect rect=self.frame;
        rect.size.height-=diff;
        rect.origin.y+=diff;
        self.frame = rect;
                
        CGRect textBgViewFrame=textBgView.frame;
        textBgViewFrame.size.height-=diff;
        textBgViewFrame.origin.y=(rect.size.height-textBgViewFrame.size.height)*0.5f;
        textBgView.frame=textBgViewFrame;
        
        rect=textView.frame;
        rect.size.height-=diff;
        textView.frame=rect;
    }
    
}

#pragma mark  notification
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion

    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
        
	CGRect containerFrame = self.frame;
    
    containerFrame.origin.y = superViewHeight - (keyboardBounds.size.height + containerFrame.size.height)+44.0f;   //44.0f  因为多了个tabbar 懒得去弄好代码了
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	self.frame=containerFrame;
    
    if([self.delegate respondsToSelector:@selector(chatPanelKeyworkShow:)])
        [self.delegate chatPanelKeyworkShow:self.frame.origin.y];

	[UIView commitAnimations];
    

}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	CGRect containerFrame = self.frame;
    containerFrame.origin.y = superViewHeight-containerFrame.size.height-2.0f;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	self.frame=containerFrame;
    if([self.delegate respondsToSelector:@selector(chatPanelKeyworkShow:)])
        [self.delegate chatPanelKeyworkShow:0.0f];

	// commit animations
	[UIView commitAnimations];
    
}




@end
