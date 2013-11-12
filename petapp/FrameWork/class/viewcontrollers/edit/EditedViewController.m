//
//  EditedViewController.m
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "EditedViewController.h"
#import "GTGZThemeManager.h"
#import "Utils.h"
@interface EditedViewController ()
-(void)keyboardWillShow:(NSNotification *)note;
-(void)finish;
@end

@implementation EditedViewController
@synthesize delegate;
@synthesize text;
- (id)init{
    self = [super init];
    if (self) {
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"finish") target:self action:@selector(finish)];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];
    textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:([Utils isIPad]?25.0f:18.0f)];
    textView.backgroundColor = [UIColor clearColor];
    //textView.textColor=([Utils isIPad]?[UIColor blackColor]:[UIColor whiteColor]);
    textView.textColor=[UIColor blackColor];
    textView.text=self.text;
    [self.view addSubview:textView];
    [textView release];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.text=nil;
    [super dealloc];
}

-(void)finish{
    if([self.delegate respondsToSelector:@selector(editedFinish:text:)])
        [self.delegate editedFinish:self text:textView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark notification

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    
    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    
    
    CGRect textViewFrame=textView.frame;
    
    
    textViewFrame.size.height=self.view.bounds.size.height-keyboardBounds.size.height;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];
}


@end
