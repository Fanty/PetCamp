//
//  SelectedFriendInGroupViewController.m
//  PetNews
//
//  Created by apple2310 on 13-9-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SelectedFriendInGroupViewController.h"
#import "AsyncTask.h"
#import "PullTableView.h"
#import "PetUser.h"
#import "ContactGroupCell.h"
#import "GTGZThemeManager.h"
#import "AppDelegate.h"
#import "ContactGroupManager.h"
#import "NoCell.h"
#import "GTGZUtils.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "DataCenter.h"
NSInteger selectedFiendContactCustomSort(id obj1, id obj2,void* context){
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


@interface SelectedFriendInGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GTGZTouchScrollerDelegate>
-(void)initSearchBar;
-(void)initTableView;
-(void)loadData;
-(void)loadShowData;
-(void)filterBlick;

-(void)btnAddClick;
@end

@implementation SelectedFriendInGroupViewController
@synthesize existsFriends;
@synthesize groupId;
- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"addContactInGroup");
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"add") target:self action:@selector(btnAddClick)];
        dicts=[[NSMutableDictionary alloc] initWithCapacity:2];

        selectedArray=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initSearchBar];
    [self initTableView];
    
    
    loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.frame=CGRectMake((self.view.frame.size.width-32.0f)*0.5f, (self.view.frame.size.height-32.0f)*0.5f, 32.0f, 32.0f);
    [self.view addSubview:loadingView];
    [loadingView release];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.groupId=nil;
    self.existsFriends=nil;
    [selectedArray release];
    [sortedKeys release];
    [dicts release];
    [showDicts release];
    [task cancel];
    [super dealloc];
}


#pragma mark method

-(void)initSearchBar{
    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    searchBar.barStyle=UIBarStyleBlackOpaque;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];

}

-(void)initTableView{
    tableView=[[PullTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(searchBar.frame)) style:UITableViewStylePlain];
    tableView.touchDelegate=self;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.view addSubview:tableView];
    [tableView release];
}

-(void)loadData{
    [task cancel];
    
    [loadingView startAnimating];
    task=[[AppDelegate appDelegate].contactGroupManager friendList:nil];
    [task setFinishBlock:^{
        [loadingView stopAnimating];
        if([task result]==nil){
            if(![task status]){
                [AlertUtils showAlert:[task errorMessage] view:self.view];
            }
        }
        else{
            NSArray* list=[task result];
            for(PetUser* model in list){
                if([model.uid isEqualToString:[DataCenter sharedInstance].user.uid])continue;
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
                
                
                for(PetUser* existsModel in self.existsFriends){
                    if([existsModel.uid isEqualToString:model.uid]){
                        [selectedArray addObject:model];
                        break;
                    }
                }
                
            }
            [self loadShowData];
        }
        task=nil;
        [tableView reloadData];
        
    }];

}

-(void)loadShowData{
    NSString* searchText=[GTGZUtils trim:searchBar.text];
    if([searchText length]<1){
        [sortedKeys release];
        sortedKeys = [[[dicts allKeys] sortedArrayUsingFunction:selectedFiendContactCustomSort context:nil] retain];
        
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
    [tableView reloadData];
}

-(void)filterBlick{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.0f;
    } completion:^(BOOL finish){
        [fliterBg removeFromSuperview];
        fliterBg=nil;
        [searchBar resignFirstResponder];
        
    }];
}

-(void)btnAddClick{
    if(task!=nil)return;
    NSMutableArray* array=[[NSMutableArray alloc] initWithCapacity:2];
    [selectedArray enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL* stop){
        PetUser* user=(PetUser*)obj;
        [array addObject:user.uid];
    }];

 
    MBProgressHUD* hud=[AlertUtils showLoading:lang(@"") view:self.view];
    [hud show:YES];
    task=[[AppDelegate appDelegate].contactGroupManager addGroupUsers:self.groupId friends:array];
    [array release];
    
    [task setFinishBlock:^{
        [hud hide:NO];
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            [AlertUtils showAlert:lang(@"addGroupSuccess") view:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:GroupUpdateNotification object:nil];
        }
    
        task=nil;
    }];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(sortedKeys==nil)
        return nil;
    else
        return [sortedKeys objectAtIndex:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(sortedKeys==nil){
        return nil;
    }
    else{
        UIImageView* myView = [[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"contact_header.png"]] autorelease];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 24.0f)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.shadowColor=[UIColor blackColor];
        titleLabel.shadowOffset=CGSizeMake(0.0f, 0.5f);
        titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=[[sortedKeys objectAtIndex:section] uppercaseString];
        [myView addSubview:titleLabel];
        [titleLabel release];
        return myView;
    }
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
        cell.textLabel.text=lang(@"failClickCell");
        return cell;
    }
    else{
        ContactGroupCell *cell = (ContactGroupCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil){
            cell = [[[ContactGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
        cell.accessoryType=[selectedArray containsObject:model]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        
        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([dicts count]<1 && task==nil){
        [self loadData];
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
        
        if([selectedArray containsObject:model]){
            [selectedArray removeObject:model];
        }
        else{
            [selectedArray addObject:model];
        }
        UITableViewCell* cell=[_tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=[selectedArray containsObject:model]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;

        
    }
}

#pragma mark searchbar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    //  [searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    if(fliterBg==nil){
        fliterBg=[UIButton buttonWithType:UIButtonTypeCustom];
        [fliterBg addTarget:self action:@selector(filterBlick) forControlEvents:UIControlEventTouchUpInside];
        fliterBg.backgroundColor=[UIColor blackColor];
        fliterBg.frame=CGRectMake(0.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:fliterBg];
    }
    fliterBg.alpha=0.0f;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        
        fliterBg.alpha=0.6f;
    } completion:^(BOOL finish){
    }];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self loadShowData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [self filterBlick];
}


@end
