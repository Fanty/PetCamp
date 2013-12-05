//
//  GroupDetailViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "GTGZScroller.h"
#import "ImageDownloadedView.h"
#import "groupModel.h"
#import "PetUser.h"
#import "MemberListViewController.h"
#import "GroupMembersView.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AsyncTask.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "GroupTextViewController.h"
#import "DataCenter.h"

@interface GroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate,UIAlertViewDelegate>
-(void)loadData;
-(void)updateAction;
@end

@implementation GroupDetailViewController{
    GTGZTableView* tableView;
    
    NSDictionary* dict;

    
    ImageDownloadedView* headerImageView;
    UILabel* grouHostLabel;
    
    
    GroupMembersView* memberView;

}
@synthesize groupModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self backNavBar];
        
        dict=[[NSDictionary dictionaryWithObjectsAndKeys:
               [NSArray arrayWithObjects:lang(@"groupMember"), nil],
               @"groupMember",
               [NSArray arrayWithObjects:lang(@"createdate"), nil],
               @"createdate",
               [NSArray arrayWithObjects:lang(@"groupId"),lang(@"location"),lang(@"groupHost"),lang(@"groupDescription"), nil],
               @"base",
               nil] retain];
        
        images=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self loadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [headerImageView release];
    headerImageView=nil;
    [grouHostLabel release];
    grouHostLabel=nil;
    
    [memberView release];
    memberView=nil;
}

- (void)dealloc{
    [headerImageView release];
    [grouHostLabel release];
    [memberView release];

    self.groupModel=nil;
    [images release];
    [dict release];
    [super dealloc];
}

#pragma mark method

-(BOOL)canBackNav{
    return (task==nil);
}

-(void)loadData{
    MBProgressHUD* progressHUD=[AlertUtils showLoading:lang(@"loading") view:self.view];
    task=[[AppDelegate appDelegate].contactGroupManager friendList:self.groupModel.groupId];
    [progressHUD show:NO];
    [task setFinishBlock:^{
        [progressHUD hide:NO];

        NSArray* array=(NSArray*)[task result];
        if([array count]<1){
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"connect_error") message:nil delegate:self cancelButtonTitle:lang(@"cancel") otherButtonTitles:lang(@"confim"), nil];
            [alertView show];
            [alertView release];
        }
        else{
            [images removeAllObjects];
            for(PetUser* petUser in array){
                if([petUser.imageHeadUrl length]>0)
                    [images addObject:petUser.imageHeadUrl];
                else
                    [images addObject:@""];
            }
            
            tableView=[[GTGZTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
            tableView.touchDelegate=self;
            tableView.dataSource=self;
            tableView.delegate=self;
            tableView.showsHorizontalScrollIndicator=NO;
            tableView.showsVerticalScrollIndicator=NO;
            tableView.backgroundColor=[UIColor grayColor];
            
            [self.view addSubview:tableView];
            [tableView release];

            if([[DataCenter sharedInstance].user.uid isEqualToString:self.groupModel.petUser.uid])
                [self rightNavBarWithTitle:lang(@"update") target:self action:@selector(updateAction)];

        }
        task=nil;

    }];

}

-(void)updateAction{
    if(task!=nil)return;
    
    MBProgressHUD* progressHUD=[AlertUtils showLoading:lang(@"loading") view:self.view];
    task=[[AppDelegate appDelegate].contactGroupManager updateGroup:self.groupModel.groupId groupname:self.groupModel.groupName description:self.groupModel.desc location:self.groupModel.location];
    [progressHUD show:NO];
    [task setFinishBlock:^{
        [progressHUD hide:NO];
        
        if(![task status]){
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:[task errorMessage] message:nil delegate:self cancelButtonTitle:lang(@"cancel") otherButtonTitles:lang(@"confim"), nil];
            [alertView show];
            [alertView release];
        }
        else{
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"updateSuccess") message:nil delegate:nil cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            

            [[AppDelegate appDelegate].contactGroupManager sync];
        }
        task=nil;
        
    }];

}

#pragma mark tableview delegate  datasource


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [dict count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* key=[[dict allKeys] objectAtIndex:section];
    NSArray* array=[dict objectForKey:key];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key=[[dict allKeys] objectAtIndex:[indexPath section]];
    NSArray* array=[dict objectForKey:key];
    NSString* text=[array objectAtIndex:[indexPath row]];
    if([text isEqualToString:lang(@"groupDescription")]){
        return  120.0f;
    }
    else if([key isEqualToString:@"groupMember"]){
        
        return [GroupMembersView height];
    }
    else{
        return 50.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* key=[[dict allKeys] objectAtIndex:[indexPath section]];
    NSArray* array=[dict objectForKey:key];
    NSString* text=[array objectAtIndex:[indexPath row]];

    UITableViewCell *cell=nil;;
    if([key isEqualToString:@"base"]){
        if([text isEqualToString:lang(@"groupHost")]){
            cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"first_host_cell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"first_host_cell"] autorelease];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.text=text;
            
            if(headerImageView==nil){
                headerImageView=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)];
                [headerImageView setUrl:groupModel.petUser.imageHeadUrl];
            }
            
            [cell addSubview:headerImageView];
            
            if(grouHostLabel==nil){
                grouHostLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width-100.0f, 0.0f)];
                grouHostLabel.numberOfLines=0;
                grouHostLabel.textColor=[UIColor blackColor];
                
                grouHostLabel.text=([groupModel.petUser.nickname length]>0?groupModel.petUser.nickname:lang(@"Administrator"));
                [grouHostLabel sizeToFit];
            }

            [cell addSubview:grouHostLabel];
            
            CGRect rect=grouHostLabel.frame;
            rect.origin.x=tableView.frame.size.width-20.0f-rect.size.width;
            rect.origin.y=(50.0f-rect.size.height)*0.5f;
            grouHostLabel.frame=rect;
            
            rect=headerImageView.frame;
            rect.origin.x=grouHostLabel.frame.origin.x-rect.size.width-5.0f;
            rect.origin.y=10.0f;
            headerImageView.frame=rect;
        }
        else if([text isEqualToString:lang(@"groupDescription")]){
            cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"first_desc_cell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"first_desc_cell"] autorelease];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text=text;
            cell.detailTextLabel.numberOfLines=0;
            cell.detailTextLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.text=self.groupModel.desc;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }
        else{
            cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"first_cell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"first_cell"] autorelease];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text=text;
            cell.detailTextLabel.textColor=[UIColor blackColor];
            cell.accessoryType=UITableViewCellAccessoryNone;

            if([text isEqualToString:lang(@"groupId")]){
                
                cell.detailTextLabel.text=self.groupModel.groupId;
            }
            else if([text isEqualToString:lang(@"location")]){
                
                cell.detailTextLabel.text=self.groupModel.location;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

            }
        }
    }
    else if([key isEqualToString:@"createdate"]){
        cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"second_cell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"second_cell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=text;
        cell.detailTextLabel.textColor=[UIColor blackColor];

        NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/HH dd:mm"];
        cell.detailTextLabel.text=[formatter stringFromDate:self.groupModel.createtime];
        [formatter release];
        

    }
    else if([key isEqualToString:@"groupMember"]){
        cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"third_cell"];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"third_cell"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if(memberView==nil){
            memberView=[[GroupMembersView alloc] initWithFrame:CGRectMake(20.0f, 5.0f, tableView.frame.size.width-60.0f, 0.0f)];
            [memberView title:text];
            
            [memberView setImages:images];
        }
        [cell addSubview:memberView];

    }
    
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString* key=[[dict allKeys] objectAtIndex:[indexPath section]];
    if([key isEqualToString:@"groupMember"]){
        MemberListViewController* controller=[[MemberListViewController alloc] init];
        controller.groupId=groupModel.groupId;
        controller.uid=groupModel.petUser.uid;
        controller.title=self.title;
        controller.showJoinGroupButton=NO;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if([key isEqualToString:@"base"]){
        if([[DataCenter sharedInstance].user.uid isEqualToString:self.groupModel.petUser.uid]){
            NSArray* array=[dict objectForKey:key];
            NSString* text=[array objectAtIndex:[indexPath row]];
            
            if([text isEqualToString:lang(@"groupDescription")]){
                GroupTextViewController* controller=[[GroupTextViewController alloc] init];
                controller.groupModel=self.groupModel;
                controller.editDesc=YES;
                controller.title=lang(@"plsinputgroupdesc");
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else if([text isEqualToString:lang(@"location")]){
                GroupTextViewController* controller=[[GroupTextViewController alloc] init];
                controller.groupModel=self.groupModel;
                controller.title=lang(@"plsinputlocation");
                
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
        }

    }
}

#pragma mark alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self loadData];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
