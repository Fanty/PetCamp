//
//  MyContactsPetListTableView.h
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyContactsPetListTableView : UITableView{
    BOOL isFans;
}

@property(assign,nonatomic) UIViewController* parentViewController;

- (id)initWithFrame:(CGRect)frame widthFans:(BOOL)fans;

@end

