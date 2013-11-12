//
//  WeiBoSettingViewController.m
//  PetNews
//
//  Created by apple2310 on 13-9-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WeiBoSettingViewController.h"
#import "GTGZThemeManager.h"
#import "DataCenter.h"
#import "PetUser.h"
#import "AccountManager.h"
#import "AppDelegate.h"
#import "AsyncTask.h"
#import "GTGZUtils.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "Utils.h"
@interface WeiBoSettingViewController ()<UIAlertViewDelegate>
-(void)btnWeiBoClick;
@end

@implementation WeiBoSettingViewController

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        [self backNavBar];
        self.title=lang(@"weibo_bind");
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    label=[[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, self.view.frame.size.width-40.0f, 50.0f)];
    textField=[[UITextField alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(label.frame), self.view.frame.size.width-40.0f, ([Utils isIPad]?52.0f:30.0f))];
    if([Utils isIPad]){
        [textField setFont:[UIFont systemFontOfSize:33.0f]];
    }
    textField.returnKeyType=UIReturnKeyDone;
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [label theme:@"weibo_tip_label"];
    label.text=lang(@"weibo_tip_label");
    
    textField.placeholder=lang(@"weibo_placeholder");
    textField.text=[DataCenter sharedInstance].user.bind_weibo;
    
    UIImage* img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"registerbutton.png"];
    [confirmButton setBackgroundImage:img forState:UIControlStateNormal];
    [confirmButton setTitle:lang(@"confirm") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(btnWeiBoClick) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame=CGRectMake(20.0f, CGRectGetMaxY(textField.frame)+20.0f, self.view.frame.size.width-40.0f, img.size.height - ([Utils isIPad]?30:0));
    if([Utils isIPad]){
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:35.0f]];
    }
    
    [self.view addSubview:label];
    [self.view addSubview:textField];
    [self.view addSubview:confirmButton];
    
    
    [label release];
    [textField release];
    
}

-(void)dealloc{
    [task cancel];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willShowViewController{
    [super willShowViewController];

    [textField becomeFirstResponder];
}

-(void)btnWeiBoClick{
    
    NSString* text=[GTGZUtils trim:textField.text];
    if([text length]<1){
        [AlertUtils showAlert:lang(@"pls_input_weibo") view:self.view];
        return;
    }
    
    [task cancel];
    PetUser* nPetUser=[DataCenter sharedInstance].user;
    PetUser* petUser = [[PetUser alloc] init];
    [petUser copyPet:nPetUser];
    petUser.bind_weibo=text;
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
    [hud show:YES];

    task=[[AppDelegate appDelegate].accountManager updateProfile:petUser];
    [task setFinishBlock:^{
        [hud hide:YES];
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"weibo_bind_success") message:@"" delegate:self cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
            [nPetUser copyPet:petUser];
        }
        [petUser release];
        task=nil;
    }];

}

#pragma mark alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
