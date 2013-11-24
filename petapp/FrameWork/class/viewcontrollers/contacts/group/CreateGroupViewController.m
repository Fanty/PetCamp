//
//  CreateGroupViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "AsyncTask.h"
#import "GTGZUtils.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GTGZScroller.h"
#import "ContactGroupManager.h"
#import "ApiError.h"

@interface CreateGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,GTGZTouchScrollerDelegate>


-(void)createGroupAction;

@end

@implementation CreateGroupViewController{
    GTGZTableView* tableView;
    
    NSArray* array;
    
    UITextField* nameField;
    UITextField* locationField;
    UITextView* descField;
    
    AsyncTask* task;
    
}

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"create_group");
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"finish") target:self action:@selector(createGroupAction)];
        array=[[NSArray arrayWithObjects:lang(@"groupName"),lang(@"location"), lang(@"plsinputgroupdesc"),nil] retain];
        
        
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    tableView=[[GTGZTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.touchDelegate=self;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:tableView];
    [tableView release];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    [nameField release];
    [locationField release];
    [descField release];
}

- (void)dealloc{
    [array release];
    [super dealloc];
}

-(BOOL)canBackNav{
    return (task==nil);
}


#pragma mark method

-(void)createGroupAction{
    
    if(task!=nil)return;
    
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [descField resignFirstResponder];

    
    NSString* name=[GTGZUtils trim:nameField.text];
    
    if([name length]<1){
        [AlertUtils showAlert:lang(@"pls_inputgroup") view:self.view];
        return;
    }
    
    NSString* location=[GTGZUtils trim:locationField.text];
    NSString* desc=[GTGZUtils trim:descField.text];
    
    [task cancel];
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
    [hud show:YES];
    task=[[AppDelegate appDelegate].contactGroupManager createGroup:name location:location desc:desc];
    [task setFinishBlock:^{
        [hud hide:NO];
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            [AlertUtils showStandAlert:lang(@"createGroupSuccess")];
            [self.navigationController popViewControllerAnimated:YES];
        }
        task=nil;
    }];

}

#pragma mark tableview delegate  datasource

- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event{
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [descField resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [descField resignFirstResponder];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [array count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [array objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[array objectAtIndex:[indexPath section]] isEqualToString:lang(@"plsinputgroupdesc")])
        return 120.0f;
    return  44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if([indexPath section]==0){
        if(nameField==nil){
            nameField=[[UITextField alloc] initWithFrame:CGRectMake(25.0f, 10.0f, _tableView.frame.size.width-50.0f, 44.0f)];
            nameField.borderStyle=UITextBorderStyleNone;
            nameField.placeholder=lang(@"plsinputgroupname");
            nameField.returnKeyType=UIReturnKeyNext;
            nameField.delegate=self;
        }
        [nameField removeFromSuperview];
        [cell addSubview:nameField];
        
    }
    else if([indexPath section]==1){
        if(locationField==nil){
            locationField=[[UITextField alloc] initWithFrame:CGRectMake(25.0f, 10.0f, _tableView.frame.size.width-50.0f, 44.0f)];
            locationField.borderStyle=UITextBorderStyleNone;
            locationField.placeholder=lang(@"plsinputlocation");
            locationField.returnKeyType=UIReturnKeyNext;
            locationField.delegate=self;
        }
        [locationField removeFromSuperview];
        [cell addSubview:locationField];

    }
    else{
        if(descField==nil){
            descField=[[UITextView alloc] initWithFrame:CGRectMake(25.0f, 10.0f, _tableView.frame.size.width-50.0f, 80.0f)];
            descField.delegate=self;
            descField.font=[UIFont systemFontOfSize:18.0f];
        }
        [descField removeFromSuperview];
        [cell addSubview:descField];

    }
    
    return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if([textField isEqual:nameField])   
        [tableView setContentOffset:CGPointZero animated:YES];
    else
        [tableView setContentOffset:CGPointMake(0.0f, 80.0f) animated:YES];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:nameField])
        [locationField becomeFirstResponder];
    else
        [descField becomeFirstResponder];
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [tableView setContentOffset:CGPointMake(0.0f, 150.0f) animated:YES];
    return YES;
}


@end
