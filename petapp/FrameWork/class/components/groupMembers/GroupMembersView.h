//
//  GroupMembersView.h
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMembersView : UIView{
    UILabel* titleLabel;
    NSMutableArray* imageViews;
    UIScrollView* scrollView;
}


+(float)height;

-(void)title:(NSString*)title;
-(void)setImages:(NSArray*)array;

@end
