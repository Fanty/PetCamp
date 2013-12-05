//
//  MyContactsPetListTableView.m
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MyContactsPetListTableView.h"
#import "DataCenter.h"
#import "PetCell.h"
#import "NoCell.h"
#import "PetNewsModel.h"
#import "PetUser.h"
#import "ContactGroupManager.h"
#import "AppDelegate.h"
#import "ContactDetailViewController.h"

@interface MyContactsPetListTableView()<UITableViewDataSource,UITableViewDelegate>
-(void)updateNotification;

@end

@implementation MyContactsPetListTableView

@synthesize parentViewController;
- (id)initWithFrame:(CGRect)frame widthFans:(BOOL)fans{
    self=[super initWithFrame:frame style:UITableViewStylePlain];
    if(self){
        isFans=fans;
        self.dataSource=self;
        self.delegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification) name:FriendUpdateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray* list=(isFans?[DataCenter sharedInstance].fansList:[DataCenter sharedInstance].friendList);
    if([list count]<1){
        return 1;
    }
    return [list count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* list=(isFans?[DataCenter sharedInstance].fansList:[DataCenter sharedInstance].friendList);
    
    if([list count]<1){
        return 44.0f;
    }
    else{
        return [PetCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* list=(isFans?[DataCenter sharedInstance].fansList:[DataCenter sharedInstance].friendList);
    
    if([list count]<1){
        NoCell *cell = (NoCell*)[_tableView dequeueReusableCellWithIdentifier:@"nocell"];
        if(cell == nil){
            cell = [[[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nocell"] autorelease];
        }
        [cell showLoading:[AppDelegate appDelegate].contactGroupManager.syncingFriend];
        return cell;
    }
    else{

        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        PetCell *cell = (PetCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[PetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        [cell headUrl:model.imageHeadUrl];
        [cell nickName:model.nickname];
        if(model.petNewsModel!=nil){
            [cell content:[NSString stringWithFormat:lang(@"newpets_content"),model.petNewsModel.desc]];
            [cell createDate:model.petNewsModel.createdate];
            [cell like:model.petNewsModel.laudCount comment:model.petNewsModel.command_count];
        }
        else{
            [cell content:lang(@"newpets_content_no")];
        }
        //[cell images:[NSArray arrayWithObjects:model.petUser.imageHeadUrl,model.petUser.imageHeadUrl,model.petUser.imageHeadUrl,model.petUser.imageHeadUrl, nil]];
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* list=(isFans?[DataCenter sharedInstance].fansList:[DataCenter sharedInstance].friendList);
    
    if([list count]<1){
        if(![AppDelegate appDelegate].contactGroupManager.syncingFriend){
            NoCell *cell=(NoCell *)[_tableView cellForRowAtIndexPath:indexPath];
            [cell showLoading:YES];
            [[AppDelegate appDelegate].contactGroupManager sync];
        }
    }
    else{
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        ContactDetailViewController* controller=[[ContactDetailViewController alloc] init];
        controller.title=model.nickname;
        controller.uid=model.uid;
        [self.parentViewController.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}



#pragma mark method


-(void)updateNotification{
    [self reloadData];
}

@end
