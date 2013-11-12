//
//  ActivityDetailHeader.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityDetailHeader;

@protocol ActivityDetailHeaderDelegate <NSObject>
@optional
-(void)joinClick:(ActivityDetailHeader*)header;
@end

@class ImageDownloadedView;


@interface ActivityDetailHeader : UIView{
    ImageDownloadedView* headerImage;
    UILabel* nameLabel;
    UILabel* dateLabel;
    
    UIImageView* commentImage;
    UILabel* commentLabel;
    UIImageView* favImage;
    UILabel* favLabel;

    
    UIImageView* lineView;
    
    UILabel* titleLabel;
    UIButton* joinButton;
    UILabel* contentLabel;
}

@property(nonatomic,assign) id<ActivityDetailHeaderDelegate> delegate;

-(void)nickname:(NSString*)nickname headerImageUrl:(NSString*)headerImageUrl title:(NSString*)title content:(NSString*)content date:(NSDate*)date comment:(int)comment join:(int)join;

-(void)comment:(int)comment;
-(void)showJoinButton:(BOOL)show;
@end
