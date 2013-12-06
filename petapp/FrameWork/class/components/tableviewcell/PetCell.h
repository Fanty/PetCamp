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
@class LikeView;

@protocol PetCellDelegate <NSObject>
-(void)petCellDidClickUserHeader:(PetCell*)cell;
@end


@interface PetCell : UITableViewCell{
    
    UIView* bgView;
    
    GTGZShadowView* shadowView;
    ImageDownloadedView* headImageView;
    UILabel* dateLabel;
    UILabel* nickNameLabel;
    UILabel* contentLabel;
    

    UIImageView* chatView;
    NSMutableArray* imageViews;
    
    LikeView* likeView;
    BOOL updateNeed;
}

@property(nonatomic,assign) id<PetCellDelegate> delegate;


-(void)headUrl:(NSString*)headUrl;
-(void)nickName:(NSString*)nickName;
-(void)createDate:(NSDate*)date;
-(void)content:(NSString*)content;
-(void)images:(NSArray*)array;
-(void)like:(int)like comment:(int)comment;
-(void)hideLike;
+(float)height;
@end
