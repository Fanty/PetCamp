//
//  ProfileTab.h
//  PetNews
//
//  Created by Fanty on 13-11-24.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileTab;

@protocol ProfileTabDelegate <NSObject>

-(void)profileTab:(ProfileTab*)profileTab click:(int)clickIndex;

@end

@interface ProfileTab : UIImageView{
    UILabel* petNumberView;
    UILabel* friendNumberView;
    UILabel* fansNumberView;
    UILabel* addNumberView;
    UILabel* messageNumberView;
}

@property(nonatomic,assign) id<ProfileTabDelegate>delegate;

-(void)petNumber:(int)petNumber friendNumber:(int)friendNumber fansNumber:(int)fansNumber addNumber:(int)addnumber messageNumber:(int)messageNumber;

@end
