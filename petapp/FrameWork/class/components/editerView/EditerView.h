//
//  EditerView.h
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditerView;


@protocol EditerViewDelegate <NSObject>

-(void)editerClick:(EditerView*)editerView click:(int)index;

@end

@interface EditerView : UIImageView{
    UIButton* camerButton;
    UIButton* phoneButton;
    UIButton* adButton;
    UIButton* faceButton;
}

@property(nonatomic,assign) id<EditerViewDelegate> delegate;

-(void)showOnlyADButton;

@end
