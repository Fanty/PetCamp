//
//  QRCodeViewController.m
//  PetNews
//
//  Created by fanty on 13-9-5.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UserProfileView.h"
#import "AppDelegate.h"
#import "PetUser.h"
#import "GTGZThemeManager.h"
#import "QRCodeGenerator.h"
#import "DataCenter.h"
#import "Utils.h"


@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self backNavBar];
        self.title=lang(@"myQRCode");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PetUser* user = [DataCenter sharedInstance].user;
    UserProfileView* profileView=[[UserProfileView alloc] initWithFrame:CGRectMake(0.0f, ([Utils isIPad]?30:0.0f), self.view.frame.size.width, 0.0f)];
    [profileView headUrl:user.imageHeadUrl];
    [profileView title:user.nickname];
    [profileView desc:user.person_desc];
    [profileView sex:user.sex];
    [profileView showAddFriend:NO];
    [profileView showAddPetNew:NO];
    
    if([DataCenter sharedInstance].user.petType==PetUserPetTypeCat){
        [profileView lovePetString:lang(@"love_cat")];
    }
    else if([DataCenter sharedInstance].user.petType==PetUserPetTypeDog){
        [profileView lovePetString:lang(@"love_dog")];
    }
    else if([DataCenter sharedInstance].user.petType==PetUserPetTypeOther){
        [profileView lovePetString:lang(@"love_other")];
    }
    
    [self.view addSubview:profileView];
    [profileView release];


    UIImageView* qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(profileView.frame), self.view.frame.size.width - 40, self.view.frame.size.width - 40)];
    
    qrCodeImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"#@!!@#%@",user.uid] imageSize:qrCodeImageView.bounds.size.width];
    [self.view addSubview:qrCodeImageView];
    [qrCodeImageView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
