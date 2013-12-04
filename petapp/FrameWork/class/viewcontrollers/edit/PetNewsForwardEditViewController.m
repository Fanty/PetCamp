//
//  PetNewsForwardEditViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsForwardEditViewController.h"

#import "GTGZThemeManager.h"
#import "EditerView.h"
#import "AppDelegate.h"
#import "PetUser.h"
#import "ForwarDetailView.h"
#import "AsyncTask.h"
#import "GTGZUtils.h"
#import "PetNewsAndActivatyManager.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "SettingManager.h"
#import "DataCenter.h"
#import "Utils.h"
#import "PetNewsModel.h"
#import "WeiboAddViewController.h"
#import "PetNewsNavigationController.h"
@interface PetNewsForwardEditViewController ()<EditerViewDelegate,WeiboAddViewControllerDelegate>


-(void)goBack;
-(void)send;
-(void)keyboardWillShow:(NSNotification *)note;
-(void)keyboardWillHide:(NSNotification *)note;

-(void)createPetNews;

@end

@implementation PetNewsForwardEditViewController
@synthesize petNewsModel;
-(id)init{
    self=[super init];
    if(self){
        [self leftNavBar:@"back_header.png" target:self action:@selector(goBack)];
        [self rightNavBarWithTitle:lang(@"send") target:self action:@selector(send)];
        
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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    float left=([Utils isIPad]?20.0f:10.0f);
    
    textView=[[UITextView alloc] initWithFrame:CGRectMake(left,left, self.view.frame.size.width-left*2.0f, 180.0f)];
    
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:([Utils isIPad]?25.0f:18.0f)];
    textView.backgroundColor = [UIColor clearColor];
    // textView.textColor=([Utils isIPad]?[UIColor blackColor]:[UIColor whiteColor]);
    textView.textColor=[UIColor blackColor];
    [self.view addSubview:textView];
    [textView release];
    
    if([self.petNewsModel.scr_post.pid length]>0){
        
        textView.text=[NSString stringWithFormat:lang(@"forward_content"),self.petNewsModel.petUser.nickname,self.petNewsModel.desc];
    }
    
    
    forwarDetailView=[[ForwarDetailView alloc] initWithFrame:CGRectMake(left, 0.0f, self.view.frame.size.width-left*2.0f, 0.0f)];
    if(self.petNewsModel.scr_post!=nil){
        [forwarDetailView headerUrl:self.petNewsModel.scr_post.petUser.imageHeadUrl name:self.petNewsModel.scr_post.petUser.nickname content:self.petNewsModel.scr_post.desc];
    }
    else{
        [forwarDetailView headerUrl:self.petNewsModel.petUser.imageHeadUrl name:self.petNewsModel.petUser.nickname content:self.petNewsModel.desc];
    }
    [self.view addSubview:forwarDetailView];
    [forwarDetailView release];
    
    editerView=[[EditerView alloc] init];
    [editerView showOnlyADButton];
    editerView.delegate=self;
    CGRect rect=editerView.frame;
    rect.origin.y=self.view.frame.size.height;
    editerView.frame=rect;
    [self.view addSubview:editerView];
    [editerView release];
    
    
    fgView=[[UIView alloc] initWithFrame:self.view.bounds];
    fgView.userInteractionEnabled=NO;
    [self.view addSubview:fgView];
    [fgView release];
}

-(void)dealloc{
    self.petNewsModel=nil;
    [task cancel];
    [loadingHud hide:YES];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    [loadingHud hide:YES];
    loadingHud=nil;
    [task cancel];
    task=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
    self.title=[DataCenter sharedInstance].user.nickname;
}

#pragma mark method

-(void)goBack{
    if(task==nil){
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)send{
    if(task!=nil)return;
    [textView resignFirstResponder];
    [task cancel];
    task=nil;
    [loadingHud hide:YES];
    loadingHud=nil;

    
    loadingHud=[AlertUtils showLoading:lang(@"loadmore_loading") view:fgView];
    [loadingHud show:NO];
    [self createPetNews];
    
    
}

-(void)createPetNews{
    [task cancel];
    NSString* content=[GTGZUtils trim:textView.text];
    NSString* scr_post_id=self.petNewsModel.scr_post.pid;
    if([scr_post_id length]<1)
        scr_post_id=self.petNewsModel.pid;
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager createPetNews:content images:nil src_post_id:scr_post_id];
    [task setFinishBlock:^{
        [loadingHud hide:YES];
        loadingHud=nil;
        
        if(![task status]){
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:[task errorMessage] message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        else{
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"forwardSuccess") message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];

            [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePetNewsListNotification object:nil];
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
        task=nil;
    }];
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
    
    
    
    
    float newHeight=self.view.bounds.size.height-keyboardBounds.size.height;
    float offset=([Utils isIPad]?20.0f:10.0f);
    
    CGRect editerFrame=editerView.frame;
    editerFrame.origin.y=newHeight-editerFrame.size.height;
    
    
    CGRect forwarFrame=forwarDetailView.frame;
    forwarFrame.origin.y=editerFrame.origin.y-forwarFrame.size.height-offset;
    
    CGRect textViewFrame=textView.frame;
    textViewFrame.origin.y=offset;
    textViewFrame.size.height=forwarFrame.origin.y-offset;
    
    
    
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	editerView.frame=editerFrame;
    forwarDetailView.frame=forwarFrame;
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    float newHeight=self.view.bounds.size.height;
    float offset=([Utils isIPad]?20.0f:10.0f);

    CGRect editerFrame=editerView.frame;
    editerFrame.origin.y=newHeight-editerFrame.size.height;
    
    
    CGRect forwarFrame=forwarDetailView.frame;
    forwarFrame.origin.y=editerFrame.origin.y-forwarFrame.size.height-offset;
    
    CGRect textViewFrame=textView.frame;
    textViewFrame.origin.y=offset;
    textViewFrame.size.height=forwarFrame.origin.y-offset;
    
    
    
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	editerView.frame=editerFrame;
    forwarDetailView.frame=forwarFrame;
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];
}

#pragma mark editer delegate

-(void)editerClick:(EditerView *)editerView click:(int)index{
    if(index==2){
        WeiboAddViewController* controller=[[WeiboAddViewController alloc] init];
        controller.delegate=self;
        PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
        [controller release];
        
        [self presentModalViewController:navController animated:YES];
        [navController release];

    }
}

#pragma mark weiboaddviewcontroller delegate

-(void)weiboAddViewController:(WeiboAddViewController *)viewController nickname:(NSString *)nickname{
    textView.text=[textView.text stringByReplacingCharactersInRange:textView.selectedRange withString:[NSString stringWithFormat:@" %@ ",nickname]];
}

-(void)weiboAddViewControllerCancel:(WeiboAddViewController *)viewController{
    textView.text=[textView.text stringByReplacingCharactersInRange:textView.selectedRange withString:@"@"];
    
}


@end
