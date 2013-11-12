//
//  ActivatyEditMainViewController.m
//  PetNews
//
//  Created by fanty on 13-8-28.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ActivatyEditMainViewController.h"
#import "GTGZThemeManager.h"
#import "ImageUploaded.h"
#import "AsyncTask.h"
#import "EditedViewController.h"
#import "GTGZUtils.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "PetNewsAndActivatyManager.h"
#import "SettingManager.h"
#import "AppDelegate.h"
#import "GTGZUtils.h"
#import "Utils.h"

@interface ActivatyEditMainViewController ()<UITableViewDataSource,UITableViewDelegate,EditedViewControllerDelegate>

@property(nonatomic,retain) NSString* contentTitle;
@property(nonatomic,retain) NSString* content;

-(void)goBack;
-(void)send;

-(void)uploadImage;
-(void)createActivaty;

@end

@implementation ActivatyEditMainViewController
@synthesize contentTitle;
@synthesize content;
-(id)init{
    self=[super init];
    
    if(self){
        self.title=lang(@"create_activaty");
        [self leftNavBar:@"back_header.png" target:self action:@selector(goBack)];
        [self rightNavBarWithTitle:lang(@"send") target:self action:@selector(send)];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    imageQueue=0;
    [imageLinks release];
    imageLinks=[[NSMutableString alloc] init];

    
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];

    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.scrollEnabled=NO;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    [self.view addSubview:tableView];
    
    [tableView release];
    
    float offset=([Utils isIPad]?30.0f:0.0f);
    
    imageUploaded=[[ImageUploaded alloc] initWithFrame:CGRectMake(offset, ([Utils isIPad]?300.0f:150.0f), self.view.frame.size.width-offset*2.0f, 0)];
    imageUploaded.parentViewController=self;
    [self.view addSubview:imageUploaded];
    [imageUploaded release];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [loadingHud hide:YES];
    loadingHud=nil;
    [task cancel];
    task=nil;
    [imageLinks release];
    imageLinks=nil;
}

-(void)dealloc{
    [task cancel];
    [loadingHud hide:YES];
    loadingHud=nil;
    self.contentTitle=nil;
    self.content=nil;
    [imageLinks release];
    [super dealloc];
}

#pragma mark table delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([Utils isIPad])
        return 80.0f;
    else
        return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.textLabel.text=lang([indexPath section]==0?@"actiavty_title":@"activaty_content");
    cell.detailTextLabel.text=([indexPath section]==0?self.contentTitle:self.content);
    if([Utils isIPad]){
        cell.textLabel.font=[UIFont boldSystemFontOfSize:25.0f];
        cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    }
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EditedViewController* controller=[[EditedViewController alloc] init];
    controller.delegate=self;
    controller.title=lang(([indexPath section]==0?@"actiavty_title":@"activaty_content"));
    controller.text=([indexPath section]==0?self.contentTitle:self.content);
    controller.view.tag=[indexPath section];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark edited text delegate

-(void)editedFinish:(EditedViewController*)controller text:(NSString*)text{
    if(controller.view.tag==0){
        self.contentTitle=text;
    }
    else{
        self.content=text;
    }
    [tableView reloadData];
}

#pragma mark method


-(void)goBack{
    [task cancel];
    task=nil;
    [loadingHud hide:YES];
    loadingHud=nil;

    [self dismissModalViewControllerAnimated:YES];
}

-(void)send{
    if(task!=nil)return;
    imageQueue=0;
    [task cancel];
    task=nil;
    [loadingHud hide:YES];
    loadingHud=nil;
    [imageLinks release];
    imageLinks=[[NSMutableString alloc] init];

    NSString* __contentTitle=[GTGZUtils trim:self.contentTitle];
    NSString* __content=[GTGZUtils trim:self.content];
    if([__contentTitle length] <1 || [__content length]<1){
        [AlertUtils showAlert:lang(@"pls_activatecontent") view:self.view];
        return;
    }
    
    loadingHud=[AlertUtils showLoading:lang(@"loadmore_loading") view:self.view];
    [loadingHud show:NO];
    [self uploadImage];
}

-(void)uploadImage{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    [task cancel];
    NSArray* images=[imageUploaded images];
    if(imageQueue<[images count]){
        UIImage* img=[images objectAtIndex:imageQueue];
        img=[GTGZUtils imageWithThumbnail:img size:CGSizeMake(480.0f, 640.0f)];
        NSData* data=UIImageJPEGRepresentation(img, 90);

        task=[[AppDelegate appDelegate].settingManager fileUpload:data type:@"activaty"];
        [task setFinishBlock:^{
            
            if([task result]!=nil){
                NSString* link=[task result];
                if([link length]>0){
                    [imageLinks appendString:link];
                    if(imageQueue<[images count]-1)
                        [imageLinks appendString:@","];
                }
            }
            
            imageQueue++;
            task=nil;
            [self uploadImage];
        }];
    }
    else{
        [self createActivaty];
    }
    [pool release];
}

-(void)createActivaty{
    
    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager createActivity:self.contentTitle content:self.content images:imageLinks start_date:[NSDate date] end_date:[NSDate date] join_date:[NSDate date]];
    
    [task setFinishBlock:^{
        [loadingHud hide:YES];
        loadingHud=nil;

        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateActivatyListNotification object:nil];
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
        task=nil;
    }];

    
    
}


@end
