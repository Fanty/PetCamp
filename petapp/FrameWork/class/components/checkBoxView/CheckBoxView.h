//
//  CheckBoxView.h
//  PetNews
//
//  Created by Grace Lai on 15/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckBoxView;
@protocol CheckBoxViewDelegate <NSObject>

-(void)clickCheckBoxView:(CheckBoxView*)checkBoxView clickIndex:(NSInteger)index;

@end

@interface CheckBoxView : UIView{

    UILabel* titleLabel;
    
    NSMutableArray* clickBoxButtonViewArray;
}

@property(nonatomic,assign)id<CheckBoxViewDelegate>delegate;

-(void)setTitle:(NSString*)title;
-(void)setCheckBoxButton:(NSArray*)array;

@end
