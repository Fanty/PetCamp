//
//  SettingMainViewController.m
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SettingMainViewController.h"
#import "GTGZThemeManager.h"
#import "ImageDownloadedView.h"
#import "PetUser.h"
#import "AppDelegate.h"
#import "ChangePasswordViewController.h"

#import "PersonDynamicViewController.h"
#import "UserProfileView.h"
#import "SettingInfoMainViewController.h"
#import "PersonDynamicViewController.h"
#import "DataCenter.h"
#import "Utils.h"

@interface SettingMainViewController ()<UITableViewDataSource,UITableViewDelegate>
-(void)initProfile;

@end

@implementation SettingMainViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"setting");
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"setting") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_setting.png"] tag:0] autorelease];
                
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self initProfile];
    CGRect rect=self.view.bounds;
    rect.origin.y=CGRectGetMaxY(profileView.frame);
    rect.size.height=rect.size.height-rect.origin.y;
    tableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    [self.view addSubview:tableView];
    
    [tableView release];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [profileView headUrl:[DataCenter sharedInstance].user.imageHeadUrl];
    [profileView title:[DataCenter sharedInstance].user.nickname];
    [profileView desc:[DataCenter sharedInstance].user.person_desc];
    [profileView sex:[DataCenter sharedInstance].user.pet_sex];
    
    if([DataCenter sharedInstance].user.petType==PetUserPetTypeCat){
        [profileView lovePetString:lang(@"love_cat")];
    }
    else if([DataCenter sharedInstance].user.petType==PetUserPetTypeDog){
        [profileView lovePetString:lang(@"love_dog")];
    }
    else if([DataCenter sharedInstance].user.petType==PetUserPetTypeOther){
        [profileView lovePetString:lang(@"love_other")];
    }

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initProfile{
    if(profileView!=nil)return;
    profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?30.0f:0.0f), self.view.frame.size.width, 0.0f)];
    [profileView showAddFriend:NO];
    [profileView showAddPetNew:NO];
    [self.view addSubview:profileView];
    [profileView release];

}

#pragma mark table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([Utils isIPad])
        return 80.0f;
    else
        return 44.0f;
}



- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;

    }
    cell.textLabel.text=lang([indexPath section]==0?@"person_activatyinfo":@"info");

    if([Utils isIPad]){
        cell.textLabel.font=[UIFont boldSystemFontOfSize:25.0f];
        cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    }

    return cell;

}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath section]==0){
        PersonDynamicViewController* controller=[[PersonDynamicViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
    else{
        SettingInfoMainViewController* controller=[[SettingInfoMainViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
}



@end
