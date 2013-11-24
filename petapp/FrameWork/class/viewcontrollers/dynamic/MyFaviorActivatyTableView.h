//
//  MyFaviorActivatyTableView.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyFaviorActivatyTableView : UITableView{

    NSArray* list;
    
    UILabel* noLabel;
}

@property(assign,nonatomic) UIViewController* parentViewController;

@end
