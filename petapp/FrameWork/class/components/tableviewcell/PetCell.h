//
//  PetCell.h
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GTGZShadowView;
@class PetCell;

@protocol PetCellDelegate <NSObject>
-(void)petCellDidClickUserHeader:(PetCell*)cell;
@end


@interface PetCell : UITableViewCell{
    
    GTGZShadowView* shadowView;
    ImageDownloadedView* headImageView;
    UILabel* nickNameLabel;
    UILabel* contentLabel;

    UIImageView* likeImageView;
    UILabel* likeLabel;
    
    UIImageView* commentImageView;
    UILabel* commentLabel;
    
    UIImageView* lineView;
    
    BOOL updateNeed;
}

@property(nonatomic,assign) id<PetCellDelegate> delegate;


-(void)headUrl:(NSString*)headUrl;
-(void)nickName:(NSString*)nickName;
-(void)content:(NSString*)content;
-(void)like:(int)like comment:(int)comment;

+(float)height;
@end
