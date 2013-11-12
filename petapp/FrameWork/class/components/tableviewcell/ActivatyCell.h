//
//  ActivatyCell.h
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GTGZShadowView;
@class ActivatyCell;

@protocol ActivatyCellDelegate <NSObject>
-(void)activatyCellDelegate:(ActivatyCell*)cell;
@end


@interface ActivatyCell : UITableViewCell{
    
    GTGZShadowView* shadowView;
    ImageDownloadedView* headImageView;
    UILabel* titleLabel;
    UILabel* descLabel;
    UILabel* smallTipLabel;
    
    UIImageView* lineView;
    
    BOOL updateNeed;
}
@property(nonatomic,assign) id<ActivatyCellDelegate> delegate;

-(void)headUrl:(NSString*)headUrl;
-(void)title:(NSString*)title;
-(void)desc:(NSString*)desc;
-(void)laud:(int)laud;
-(void)tip:(NSString*)tip;

+(float)height;
@end
