//
//  WeiboAddViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-19.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "WeiboAddViewController.h"
#import "GTGZThemeManager.h"
#import "ContactTableView.h"
#import "Utils.h"
#import "GTGZUtils.h"

@interface WeiboAddViewController ()<UISearchBarDelegate>
-(void)backClick;
-(void)checkSearchText:(NSString*)searchText;
@end

@implementation WeiboAddViewController

- (id)init{
    self = [super init];
    if (self) {
        self.title=lang(@"contacts");
        // Custom initialization
        [self leftNavBar:@"back_header.png" target:self action:@selector(backClick)];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    searchBar.barStyle=UIBarStyleBlackOpaque;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    if([Utils isIPad])
        adLabel=[[UILabel alloc] initWithFrame:CGRectMake(35.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width-70.0f, 0.0f)];
    else
        adLabel=[[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width-40.0f, 0.0f)];
    [adLabel theme:@"WeiboAdd_title"];
    [self.view addSubview:adLabel];
    [adLabel release];
    
    contactTableView=[[ContactTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(adLabel.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adLabel.frame)) style:UITableViewStylePlain];
    //contactTableView.parentViewController=self;
    [self.view addSubview:contactTableView];
    [contactTableView release];

    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark searchbar delegate


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)_searchBar{
    //  [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    searchText=[GTGZUtils trim:searchText];
    [contactTableView searchText:searchText];

    [self checkSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=nil;
    [searchBar resignFirstResponder];
    [contactTableView searchText:nil];
    [self checkSearchText:nil];

}


#pragma mark method

-(void)backClick{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)checkSearchText:(NSString*)searchText{
    if([searchText length]<1){
        adLabel.text=nil;
        if(adLabel.frame.size.height>0.0f){
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGRect rect=adLabel.frame;
                rect.size.height=0.0f;
                adLabel.frame=rect;
                
                contactTableView.frame=CGRectMake(0.0f, CGRectGetMaxY(adLabel.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adLabel.frame));
                
            } completion:^(BOOL finish){
                
                
            }];
        }
    }
    else{
        adLabel.text=[NSString stringWithFormat:@"@%@",searchText];
        
        if(adLabel.frame.size.height<1.0f){
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGRect rect=adLabel.frame;
                if([Utils isIPad])
                    rect.size.height=60.0f;
                else
                    rect.size.height=45.0f;
                adLabel.frame=rect;
                
                contactTableView.frame=CGRectMake(0.0f, CGRectGetMaxY(adLabel.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adLabel.frame));
                
            } completion:^(BOOL finish){
                
                
            }];
        }
    }
}

@end
