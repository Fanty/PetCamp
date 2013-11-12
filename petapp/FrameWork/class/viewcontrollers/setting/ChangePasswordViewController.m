//
//  ChangePasswordViewController.m
//  PetNews
//
//  Created by Grace Lai on 21/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AsyncTask.h"
#import "AppDelegate.h"
#import "AccountManager.h"
#import "GTGZUtils.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "Utils.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)changePassword;
@end

@implementation ChangePasswordViewController

- (id)init{
    self = [super init];
    if (self) {
        
        self.title = lang(@"password_setting");
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"confirm") target:self action:@selector(changePassword)];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float spacing = ([Utils isIPad]?262.0f:130.0f);
    float orginX = ([Utils isIPad]?200.0f:110.0f);
    float orginY = ([Utils isIPad]?20.0f:8.0f);
    float h = ([Utils isIPad]?80.0f:30.0f);
 
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(orginX, orginY, self.view.frame.size.width-spacing, h)];
    passwordField.borderStyle = UITextBorderStyleNone;
    passwordField.placeholder = lang(@"plsInputPassword");
    passwordField.returnKeyType = UIReturnKeyNext;
    passwordField.delegate = self;
    passwordField.tag = 1001;
    if([Utils isIPad]){
        [passwordField setFont:[UIFont systemFontOfSize:26.0f]];
    }

    passwordField.secureTextEntry = YES;
//    [self.view addSubview:passwordField];
//    [passwordField release];
    
    newPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(orginX,orginY, self.view.frame.size.width-spacing, h)];
    newPasswordField.borderStyle = UITextBorderStyleNone;
    newPasswordField.placeholder = lang(@"plsInputPassword");
    newPasswordField.returnKeyType = UIReturnKeyNext;
    newPasswordField.secureTextEntry = YES;
    newPasswordField.delegate = self;
    newPasswordField.tag = 1002;
    if([Utils isIPad]){
        [newPasswordField setFont:[UIFont systemFontOfSize:26.0f]];
    }

//    [self.view addSubview:newPasswordField];
//    [newPasswordField release];
    
    rePassworddField = [[UITextField alloc] initWithFrame:CGRectMake(orginX, orginY, self.view.frame.size.width-spacing, h)];
    rePassworddField.borderStyle = UITextBorderStyleNone;
    rePassworddField.placeholder = lang(@"plsInputPassword");
    rePassworddField.returnKeyType = UIReturnKeyDone;
    rePassworddField.secureTextEntry = YES;
    rePassworddField.delegate = self;
    rePassworddField.tag = 1003;
    if([Utils isIPad]){
        [rePassworddField setFont:[UIFont systemFontOfSize:26.0f]];
    }

//    [self.view addSubview:rePassworddField];
//    [rePassworddField release];
    
    
    UITableView* groupTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    groupTableView.dataSource = self;
    groupTableView.delegate = self;
    groupTableView.scrollEnabled = NO;
    groupTableView.backgroundView=nil;
    
    groupTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:groupTableView];
    [groupTableView release];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [passwordField release];
    [newPasswordField release];
    [rePassworddField release];
    [super dealloc];
}

#pragma mark method
-(void)backClick{
    if(task==nil){
        NSLog(@"backClick");
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)changePassword{
    if(task==nil){
        
        NSString* oldPassword=[GTGZUtils trim:passwordField.text];
        NSString* newPassword=[GTGZUtils trim:newPasswordField.text];
        NSString* rePassword=[GTGZUtils trim:rePassworddField.text];
        
        if([oldPassword length]< 1  || [newPassword length]<1){
            [AlertUtils showAlert:lang(@"pls_input_password") view:self.view];
            return;
        }
        
        if(![newPassword isEqualToString:rePassword]){
            [AlertUtils showAlert:lang(@"password_not_same") view:self.view];
            return;
        }

        MBProgressHUD* loadingView=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
        [loadingView show:NO];
        task=[[AppDelegate appDelegate].accountManager updatePassword:oldPassword newPassword:newPassword];
        [task setFinishBlock:^{
        
            [loadingView hide:NO];
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
            }
            else{
                [AlertUtils showAlert:lang(@"success_password") view:self.view];
            }
            task=nil;
        }];
    }
}


#pragma mark UITextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    switch (textField.tag) {
        case 1001:{
            
            [passwordField resignFirstResponder];
            [newPasswordField becomeFirstResponder];

            break;
        }
        case 1002:{
        
            [newPasswordField resignFirstResponder];
            [rePassworddField becomeFirstResponder];
            break;
        }
        case 1003:{
            [rePassworddField resignFirstResponder];
            break;
        }
            
        default:
            break;
    }
    
    
    return YES;

}

#pragma mark UITabelView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([Utils isIPad])
        return 80.0f;
    else
        return 44.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *identifier = @"keyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
  

//    [self removeTableViewCellSubView:cell];
    
    NSString* title = nil;

    if([indexPath section] == 0){
        [cell addSubview:passwordField];
        title = lang(@"oldPassword");
    }
    else if([indexPath section] == 1){

        [cell addSubview:newPasswordField];
        title = lang(@"newPassword");

    }
    else if([indexPath section] == 2){
        [cell addSubview:rePassworddField];
        title = lang(@"repassword");

    }
    
    cell.textLabel.text = title;
    if([Utils isIPad]){
        cell.textLabel.font=[UIFont boldSystemFontOfSize:25.0f];
        cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    }


    return cell;
    
}

-(void)removeTableViewCellSubView:(UITableViewCell*)cell{

    for (UIView* view in [cell subviews]){
        [view removeFromSuperview];
    }

}


@end
