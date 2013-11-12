//
//  AddFriendSelectViewController.m
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "AddFriendSelectViewController.h"
#import "SearchFGViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "GTGZUtils.h"
#import "AsyncTask.h"
#import "MBProgressHUD.h"
#import "AlertUtils.h"
#import "ZBarReaderViewController.h"
#import "ContactDetailViewController.h"
#import "Utils.h"


@interface AddFriendSelectViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ZBarReaderDelegate>

@end

@implementation AddFriendSelectViewController

- (id)init{
    self = [super init];
    if (self) {
        [self backNavBar];
        self.title=lang(@"add");
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UITableView* tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundView=nil;

    [self.view addSubview:tableView];
    [tableView release];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [task cancel];
    [super dealloc];
}


#pragma mark method

-(BOOL)canBackNav{
    return (task==nil);
}

#pragma mark table delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor=[UIColor grayColor];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section==0?2:1);
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([Utils isIPad])
        return 80.0f;
    else
        return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }

    if([indexPath section]==0){
        cell.textLabel.text=lang([indexPath row]==0?@"add_firned":@"add_group");
    }
    else if([indexPath section]==1){
        cell.textLabel.text=lang(@"scan");
    }
    else if([indexPath section]==2){
        cell.textLabel.text=lang(@"create_group");

    }
    
    if([Utils isIPad]){
        cell.textLabel.font=[UIFont boldSystemFontOfSize:25.0f];
        cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([indexPath section]==0){
        SearchFGViewController* controller=[[SearchFGViewController alloc] init];
        controller.isSearchGroup=([indexPath row]==1);
        controller.title=lang([indexPath row]==0?@"add_firned":@"add_group");
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if([indexPath section]==1){
        [self scanQRCode];
    }
    else if([indexPath section]==2){
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:lang(@"pls_inputgroup") message:nil delegate:self cancelButtonTitle:lang(@"cancel") otherButtonTitles:lang(@"confirm"), nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        [alert show];
        [alert release];

    }
}


-(void)scanQRCode{
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.wantsFullScreenLayout = NO;
    reader.showsZBarControls = NO;
    [self setOverlayPickerView:reader];
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
    
}

- (void)dismissOverlayView:(id)sender{
    
    [self dismissModalViewControllerAnimated: YES];
    
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader

{
    
    //清除原有控件
    
    for (UIView *temp in [reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }
    
    //画中间的基准线
    CGRect rect = CGRectMake(40, 220, 240, 1);
    if([Utils isIPad]){
        rect = CGRectMake(104, 512, 560, 1);
    }
    
    UIView* line = [[UIView alloc] initWithFrame:rect];
    
    line.backgroundColor = [UIColor redColor];
    
    [reader.view addSubview:line];
    
    [line release];
    
    
    
    
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ([Utils isIPad]?204:80))];
    
    upView.alpha = 0.3;
    
    upView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:upView];
    
    //用于说明的label
    
    rect = CGRectMake(15, 20, 290, 50);
    if([Utils isIPad]){
        rect = CGRectMake(104, 50, 560, 100);
    }
    
    UILabel * labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=rect;
    
    labIntroudction.numberOfLines=2;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=lang(@"qrCodeMsg");
    if([Utils isIPad])
        labIntroudction.font = [UIFont systemFontOfSize:32];
    
    [upView addSubview:labIntroudction];
    
    [labIntroudction release];
    
    [upView release];
    
    //左侧的view
    
    rect = CGRectMake(0, 80, 20, 280);
    if([Utils isIPad]){
        rect = CGRectMake(0, 204, 104, 560);
    }
    
    UIView *leftView = [[UIView alloc] initWithFrame:rect];
    
    leftView.alpha = 0.3;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:leftView];
    
    [leftView release];
    
    //右侧的view
    rect = CGRectMake(300, 80, 20, 280);
    if([Utils isIPad]){
        rect = CGRectMake(664, 204, 104, 560);
    }
    UIView *rightView = [[UIView alloc] initWithFrame:rect];
    
    rightView.alpha = 0.3;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:rightView];
    
    [rightView release];
    
    //底部view
    rect = CGRectMake(0, 360, self.view.frame.size.width, 120);
    if([Utils isIPad]){
        rect = CGRectMake(0, 764, self.view.frame.size.width, 260);
    }
    UIView * downView = [[UIView alloc] initWithFrame:rect];
    
    downView.alpha = 0.3;
    
    downView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:downView];
    
    [downView release];
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancelButton.alpha = 0.4;
    
    rect = CGRectMake(20, 390, 280, 40);
    if([Utils isIPad]){
        rect = CGRectMake(104, 844, 560, 60);
    }
    [cancelButton setFrame:rect];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    if([Utils isIPad]){
         [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];
    }
    else{
         [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
   
    
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    
    [reader.view addSubview:cancelButton];
    
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissModalViewControllerAnimated: NO];
    

   
    NSRange range = [symbol.data rangeOfString:@"#@!!@#"];
    if(range.location == NSNotFound){
    
        //判断是否包含 头'http:'
        //NSString *regex = @"http+:[^\\s]*";
       // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        //判断是否包含 头'ssid:'
        //NSString *ssid = @"ssid+:[^\\s]*";
        //NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
        
        NSLog(@"%@",symbol.data);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:symbol.data
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        [alert show];
        [alert release];
        
        
        return;
    }



    NSString* userId = [symbol.data substringWithRange:NSMakeRange(range.length, symbol.data.length - range.length)];


    ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
    controller.title=lang(@"scanUser");
    controller.uid=userId;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];









}



#pragma mark alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        UITextField* textField = [alertView textFieldAtIndex:0];
        NSString* groupName=[GTGZUtils trim:textField.text];
        if([groupName length]>0){
            [task cancel];
            MBProgressHUD* hud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
            [hud show:YES];
            task=[[AppDelegate appDelegate].contactGroupManager createGroup:groupName];
            [task setFinishBlock:^{
                [hud hide:NO];
                if(![task status]){
                    [AlertUtils showAlert:[task errorMessage] view:self.view];
                }
                task=nil;
            }];
        }
    }
}

@end
