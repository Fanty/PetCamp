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
#import "iCarousel.h"
#import "MemberListViewController.h"
#import "GroupMembersView.h"

@interface GroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate>

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
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    tableView=[[GTGZTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.touchDelegate=self;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor grayColor];
    
    [self.view addSubview:tableView];
    [tableView release];

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
    [dict release];
    [super dealloc];
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
            cell.detailTextLabel.text=@"oifjsdfjfo isdofijdsaoijfoiajfioadsfio aifioadof diosf aiofioads fiodaiofoiasdfoadfosfo;aj foijsafoiofjojfoiajfioa odfiaoijfoijdaso;fjoadfjoafojasjfoai;sdjfiojsafoijsajofaosdfjaoij";

        }
        else{
            cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"first_cell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"first_cell"] autorelease];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text=text;
            cell.detailTextLabel.textColor=[UIColor blackColor];
            if([text isEqualToString:lang(@"groupId")]){
                
                cell.detailTextLabel.text=groupModel.groupId;
            }
            else if([text isEqualToString:lang(@"location")]){
                
                cell.detailTextLabel.text=@"location";
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

        cell.detailTextLabel.text=@"时间";
        

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
            
            NSArray* array=@[@"http://www.bai",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om",@"http://www.baiduc.om"];
            [memberView setImages:array];
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
}

#pragma mark 

@end
