//
//  SettingMainViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SettingInfoMainViewController.h"
#import "GTGZThemeManager.h"
#import "ImageDownloadedView.h"
#import "PetUser.h"
#import "AppDelegate.h"
#import "ChangePasswordViewController.h"
#import "PersonalInfoViewController.h"
#import "QRCodeViewController.h"

#import "PersonDynamicViewController.h"
#import "WeiBoSettingViewController.h"
#import "DataCenter.h"
#import "AsyncTask.h"
#import "AccountManager.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "ServiceWebViewController.h"
#import "Utils.h"

@interface SettingInfoMainViewController ()<UITableViewDataSource,UITableViewDelegate>
-(void)switchChange;
@end

@implementation SettingInfoMainViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"setting");
        // Custom initialization
       // [self backNavBar];
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:lang(@"setting") image:[[GTGZThemeManager sharedInstance] imageByTheme:@"tab_setting.png"] tag:0] autorelease];
        
        if([[DataCenter sharedInstance].user.accountType length]<1){
            list=[[NSArray arrayWithObjects:lang(@"person_setting"),lang(@"qrcode_info"),lang(@"password_setting"),lang(@"weibo_bind"),lang(@"online_setting"),lang(@"privacy_info"), nil] retain];

        }
        else{
            list=[[NSArray arrayWithObjects:lang(@"person_setting"),lang(@"qrcode_info"),lang(@"online_setting"),lang(@"privacy_info"), nil] retain];
        }
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
    [tableView reloadData];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [onlineSwitch release];
    onlineSwitch=nil;
    [onlineTask cancel];
    onlineTask=nil;
    // Dispose of any resources that can be recreated.
}

-(void)willShowViewController{
    [super willShowViewController];

    [tableView reloadData];
}

-(void)dealloc{
    [onlineTask cancel];
    [onlineSwitch release];
    [list release];
    [super dealloc];
}

#pragma mark method

#pragma mark table delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [list count];
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



-(void)removeSubView:(UITableViewCell*)cell subView:(UIView*)subView{
    for(UIView* view in cell.subviews){
        if([view isEqual:subView]){
            [view removeFromSuperview];
            return;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* title=[list objectAtIndex:[indexPath section]];
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
    }
    
    if([title isEqualToString:lang(@"online_setting")]){
        if(onlineSwitch ==nil){
            onlineSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-([Utils isIPad]?150:100), (([Utils isIPad]?80.0f:44.0f)-27.0f)*0.5f, 79.0f, 27.0f)];
            [onlineSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
        }
        onlineSwitch.on=(![DataCenter sharedInstance].user.online);
        [cell addSubview:onlineSwitch];
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    else{
        [self removeSubView:cell subView:onlineSwitch];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        
    }
    
    cell.textLabel.text=title;
    
    if([title isEqualToString:lang(@"weibo_bind")]){
        cell.detailTextLabel.text=[DataCenter sharedInstance].user.bind_weibo;
    }
    if([Utils isIPad]){
        cell.textLabel.font=[UIFont boldSystemFontOfSize:25.0f];
        cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    }

    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* title=[list objectAtIndex:[indexPath section]];

    
    if([title isEqualToString:lang(@"person_setting")]){
        PersonalInfoViewController* personnalInfoViewController = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:personnalInfoViewController animated:YES];
        [personnalInfoViewController release];

    }
    else if([title isEqualToString:lang(@"qrcode_info")]){
        QRCodeViewController* qrCodeViewController = [[QRCodeViewController alloc] init];
        [self.navigationController pushViewController:qrCodeViewController animated:YES];
        [qrCodeViewController release];
    }
    else if([title isEqualToString:lang(@"password_setting")]){
        ChangePasswordViewController* changePasswordViewController = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
        [changePasswordViewController release];

    }
    else if([title isEqualToString:lang(@"weibo_bind")]){
        WeiBoSettingViewController* controller = [[WeiBoSettingViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
    else if([title isEqualToString:lang(@"privacy_info")]){
        ServiceWebViewController* controller=[[ServiceWebViewController alloc] init];
        controller.isPrivacy=YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];

    }
    
}


-(void)switchChange{
    if(onlineTask==nil){
        [onlineTask cancel];
        PetUser* nPetUser=[DataCenter sharedInstance].user;
        PetUser* petUser = [[PetUser alloc] init];
        [petUser copyPet:nPetUser];
        petUser.online=(!onlineSwitch.on);
        MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
        [hud show:YES];
        onlineTask=[[AppDelegate appDelegate].accountManager updateProfile:petUser];
        [onlineTask setFinishBlock:^{
            [hud hide:NO];
            if(![onlineTask status]){
                [AlertUtils showAlert:[onlineTask errorMessage] view:self.view];
            }
            else{                
                [nPetUser copyPet:petUser];
            }
            [petUser release];
            onlineTask=nil;
        }];
    }
}

@end
