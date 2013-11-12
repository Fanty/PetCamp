//
//  ContactTableView.m
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ContactTableView.h"
#import "AsyncTask.h"
#import "PullToRefresh.h"
#import "ContactGroupCell.h"
#import "PetUser.h"
#import "ContactDetailViewController.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "AlertUtils.h"
#import "GTGZThemeManager.h"
#import "NoCell.h"

NSInteger contactCustomSort(id obj1, id obj2,void* context){
    if([obj1 length]<1)
        return (NSComparisonResult)NSOrderedAscending;
    const char* key1=[obj1 UTF8String];
    const char* key2=[obj2 UTF8String];
    
    if(*key1>*key2)
        return (NSComparisonResult)NSOrderedDescending;
    else if(*key1<*key2)
        return (NSComparisonResult)NSOrderedAscending;
    else
        return (NSComparisonResult)NSOrderedSame;
};


@interface ContactTableView()<GTGZTouchScrollerDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)retryClick;
-(void)loadShowData;
-(void)updateNotification;
@end

@implementation ContactTableView

@synthesize parentViewController;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        self.touchDelegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addPullToRefreshWithActionHandler:^{
            DLog(@"refresh dataSource");
            [self loadData];
        }];
        [self.pullToRefreshView triggerRefresh:YES];
        
        dicts=[[NSMutableDictionary alloc] initWithCapacity:2];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotification) name:FriendUpdateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [searchText release];
    [sortedKeys release];
    [dicts release];
    [showDicts release];
    [task cancel];
    [super dealloc];
}


#pragma mark table delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sortedKeys;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [showDicts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(sortedKeys==nil)
        return [[[showDicts allValues] objectAtIndex:0] count];
    else{
        NSArray* array=[showDicts objectForKey:[sortedKeys objectAtIndex:section]];
        return [array count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView* myView = [[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"contact_header.png"]] autorelease];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 24.0f)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.shadowColor=[UIColor blackColor];
    titleLabel.shadowOffset=CGSizeMake(0.0f, 0.5f);
    titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    if(sortedKeys!=nil)
        titleLabel.text=[[sortedKeys objectAtIndex:section] uppercaseString];
    else
        titleLabel.text=lang(@"searchResult");
    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}


- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([dicts count]<1 && task==nil){
        return 44.0f;
    }
    else{
        return [ContactGroupCell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([dicts count]<1 && task==nil){
        NoCell *cell = (NoCell*)[_tableView dequeueReusableCellWithIdentifier:@"nocell"];
        if(cell == nil){
            cell = [[[NoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nocell"] autorelease];
        }
        return cell;
    }
    else{
        ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        NSArray* list=nil;
        if(sortedKeys==nil){
            list=[[showDicts allValues] objectAtIndex:0];
        }
        else{
            list=[showDicts objectForKey:[sortedKeys objectAtIndex:[indexPath section]]];
        }
        
        PetUser* model=[list objectAtIndex:[indexPath row]];
        
        [cell headUrl:model.imageHeadUrl];
        [cell name:model.nickname];
        [cell desc:model.person_desc];
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([dicts count]<1 && task==nil){
        [self.pullToRefreshView triggerRefresh:YES];
    }
    else{
        NSArray* list=nil;
        if(sortedKeys==nil){
            list=[[showDicts allValues] objectAtIndex:0];
        }
        else{
            list=[showDicts objectForKey:[sortedKeys objectAtIndex:[indexPath section]]];
        }

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
    [self.pullToRefreshView triggerRefresh:YES];

}
-(void)clear{
    [task cancel];
    task=nil;
    [self releasePullToRefresh];
}

-(void)retryClick{
    [self.pullToRefreshView triggerRefresh:YES];
}

-(void)loadData{
    [task cancel];

    NSDate* date = [NSDate date];
    [self.pullToRefreshView setLastUpdatedDate:date];
    

    task=[[AppDelegate appDelegate].contactGroupManager friendList:nil];
    [task setFinishBlock:^{
        [self.pullToRefreshView stopAnimating];

        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self];
            }
        }
        else{
            NSArray* list=[task result];
            [dicts removeAllObjects];
            [sortedKeys release];
            sortedKeys=nil;
            [showDicts removeAllObjects];
            [showDicts release];
            showDicts=nil;
            for(PetUser* model in list){
                NSMutableArray* array=nil;
                for(NSString* key in [dicts allKeys]){
                    if([key isEqualToString:model.key]){
                        array=[dicts objectForKey:key];
                        break;
                    }
                }
                if(array==nil){
                    array=[[NSMutableArray alloc] initWithCapacity:3];
                    [dicts setObject:array forKey:model.key];
                    [array release];
                }
                [array addObject:model];
                
            }
            [self loadShowData];
        }
        task=nil;

    }];
    
}

-(void)loadShowData{
    if([searchText length]<1){
        [sortedKeys release];
        sortedKeys = [[[dicts allKeys] sortedArrayUsingFunction:contactCustomSort context:nil] retain];
        
        [showDicts release];
        showDicts=[dicts retain];
    }
    else{
        [sortedKeys release];
        sortedKeys=nil;
        [showDicts release];
        showDicts=[[NSMutableDictionary alloc] initWithCapacity:1];
        NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:3];
        for(NSArray* _array in [dicts allValues]){
            for(PetUser* model in _array){
                if([[model.nickname lowercaseString] rangeOfString:searchText].length>0){
                    [array addObject:model];
                }
            }
        }
        [showDicts setObject:array forKey:@""];
        [array release];
    }
    [self reloadData];

}

-(void)searchText:(NSString*)value{
    [searchText release];
    searchText=[value retain];
    [self loadShowData];
}


@end
