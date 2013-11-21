//
//  WeiboAddViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-19.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class ContactTableView;
@class WeiboAddViewController;

@protocol WeiboAddViewControllerDelegate <NSObject>
-(void)weiboAddViewController:(WeiboAddViewController*)viewController nickname:(NSString*)nickname;

@end

@interface WeiboAddViewController : BaseViewController{
    UISearchBar* searchBar;
    
    UIButton* adButton;
    UILabel* adLabel;
    ContactTableView* contactTableView;

}


@property(assign,nonatomic) id<WeiboAddViewControllerDelegate> delegate;

@end
