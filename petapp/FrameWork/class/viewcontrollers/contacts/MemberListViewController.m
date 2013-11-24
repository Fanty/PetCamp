//
//  ContactByGropuViewController.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MemberListViewController.h"
#import "ContactByGroupView.h"
#import "AsyncTask.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "DataCenter.h"
#import "PetUser.h"
#import "RootViewController.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "SelectedFriendInGroupViewController.h"
@interface MemberListViewController ()<UIActionSheetDelegate>
-(void)addGroupClick;
@end

@implementation MemberListViewController
@synthesize showJoinGroupButton;
@synthesize groupId;
@synthesize uid;
-(id)init{
    self=[super init];
    if(self){
        self.showJoinGroupButton=YES;
        [self backNavBar];
        [self rightNavBar:@"menu_header.png" target:self action:@selector(addGroupClick)];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    contactTableView=[[ContactByGroupView alloc] init];
    contactTableView.frame=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    contactTableView.groupId=self.groupId;
    contactTableView.parentViewController=self;
    [self.view addSubview:contactTableView];
    [contactTableView release];

    [contactTableView loadData];
    
    if(!self.showJoinGroupButton && ![[DataCenter sharedInstance].user.uid isEqualToString:self.uid]){
        self.navigationItem.rightBarButtonItem=nil;
    }

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.groupId=nil;
    self.uid=nil;
    [super dealloc];
}

#pragma mark method

-(BOOL)canBackNav{
    return (task==nil);
}
-(void)addGroupClick{
    if(task==nil){
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];

        if(self.showJoinGroupButton){
            [sheet addButtonWithTitle:lang(@"addGroup")];
            sheet.cancelButtonIndex=1;
        }
        if([[DataCenter sharedInstance].user.uid isEqualToString:self.uid]){
            [sheet addButtonWithTitle:lang(@"addContactInGroup")];
            sheet.cancelButtonIndex++;
        }
        [sheet addButtonWithTitle:lang(@"cancel")];
        [sheet showInView:[AppDelegate appDelegate].rootViewController.view];
        
        [sheet release];
    }
}


#pragma mark  actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(self.showJoinGroupButton){
        if(buttonIndex==0){
            
            if(task==nil){
                MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
                [hud show:YES];
                task=[[AppDelegate appDelegate].contactGroupManager addGroupUser:self.groupId friend_id:[DataCenter sharedInstance].user.uid];
                [task setFinishBlock:^{
                    [hud hide:NO];
                    task=nil;
                    [contactTableView triggerRefresh];
                    [AlertUtils showAlert:lang(@"contactGroupIsSend") view:self.view];
                }];
            }
            
        }
        else if(buttonIndex==1 && [[DataCenter sharedInstance].user.uid isEqualToString:self.uid]){
            SelectedFriendInGroupViewController* controller=[[SelectedFriendInGroupViewController alloc] init];
            controller.groupId=self.groupId;
            controller.existsFriends=[contactTableView contacts];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
    else{
        if(buttonIndex==0 ){
            SelectedFriendInGroupViewController* controller=[[SelectedFriendInGroupViewController alloc] init];
            controller.groupId=self.groupId;
            controller.existsFriends=[contactTableView contacts];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
    
}

@end
