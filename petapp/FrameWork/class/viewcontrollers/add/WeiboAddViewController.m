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
#import "PetUser.h"

@interface WeiboAddViewController ()<UISearchBarDelegate,ContactTableViewDelegate>
-(void)backClick;
-(void)selectedButtonClick;
-(void)checkSearchText:(NSString*)searchText;
@end

@implementation WeiboAddViewController

@synthesize delegate;

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
    
    
    adButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if([Utils isIPad]){
        adButton.frame=CGRectMake(35.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width-70.0f, 0.0f);
    }
    else{
        adButton.frame=CGRectMake(20.0f, CGRectGetMaxY(searchBar.frame), self.view.frame.size.width-40.0f, 0.0f);

    }
    adLabel=[[UILabel alloc] initWithFrame:adButton.bounds];

    [adLabel theme:@"WeiboAdd_title"];
    [adButton addTarget:self action:@selector(selectedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [adButton addSubview:adLabel];
    [self.view addSubview:adButton];
    [adLabel release];
    
    contactTableView=[[ContactTableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(adButton.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adButton.frame)) style:UITableViewStylePlain];
    contactTableView.contactDelegate=self;
    [self.view addSubview:contactTableView];
    [contactTableView release];

    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [super dealloc];
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

#pragma mark contacttableview delegate


-(void)contactTableViewDidSelect:(ContactTableView *)contactTableView user:(PetUser *)user{
    
    if([self.delegate respondsToSelector:@selector(weiboAddViewController:nickname:)])
        [self.delegate weiboAddViewController:self nickname:[NSString stringWithFormat:@"@%@",user.nickname]];
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark method

-(void)backClick{
    if([self.delegate respondsToSelector:@selector(weiboAddViewControllerCancel:)])
        [self.delegate weiboAddViewControllerCancel:self];

    [self dismissModalViewControllerAnimated:YES];
}

-(void)selectedButtonClick{
    if([self.delegate respondsToSelector:@selector(weiboAddViewController:nickname:)])
        [self.delegate weiboAddViewController:self nickname:adLabel.text];
    
    [self dismissModalViewControllerAnimated:YES];

}

-(void)checkSearchText:(NSString*)searchText{
    if([searchText length]<1){
        adLabel.text=nil;
        if(adLabel.frame.size.height>0.0f){
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGRect rect=adButton.frame;
                rect.size.height=0.0f;
                adButton.frame=rect;
                
                adLabel.frame=adButton.bounds;
                
                contactTableView.frame=CGRectMake(0.0f, CGRectGetMaxY(adButton.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adButton.frame));
                
            } completion:^(BOOL finish){
                
                
            }];
        }
    }
    else{
        adLabel.text=[NSString stringWithFormat:@"@%@",searchText];

        if(adLabel.frame.size.height<1.0f){
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGRect rect=adButton.frame;
                if([Utils isIPad])
                    rect.size.height=60.0f;
                else
                    rect.size.height=45.0f;
                adButton.frame=rect;
                adLabel.frame=adButton.bounds;

                contactTableView.frame=CGRectMake(0.0f, CGRectGetMaxY(adButton.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(adButton.frame));
                
            } completion:^(BOOL finish){
                
                
            }];
        }
    }
}

@end
