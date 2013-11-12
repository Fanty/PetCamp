//
//  UserProfileView.h
//  PetNews
//
//  Created by fanty on 13-8-23.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class UserProfileView;
@protocol UserProfileViewDelegate <NSObject>
@optional
-(void)profileDidSendPetNews:(UserProfileView*)profileView;
-(void)profileDidAddFriend:(UserProfileView*)profileView;

@end

@interface UserProfileView : UIView{
    ImageDownloadedView* headImageView;
    UILabel* titleLabel;
    UILabel* descLabel;
    UIImageView* sexImageView;
    
    UILabel* lovePet;
    
    UIButton* addPetNewButton;
    UIButton* addFriendButton;
    BOOL updateNeed;

}
@property(nonatomic,assign) id<UserProfileViewDelegate> delegate;
-(void)headUrl:(NSString*)headUrl;
-(void)title:(NSString*)title;
-(void)desc:(NSString*)desc;
-(void)sex:(BOOL)sex;
-(void)lovePetString:(NSString*)value;
-(void)showAddFriend:(BOOL)value;
-(void)showAddPetNew:(BOOL)value;
-(void)isContact:(BOOL)value;
-(void)allWhite;
@end
