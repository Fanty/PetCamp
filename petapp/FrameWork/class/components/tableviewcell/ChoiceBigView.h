//
//  ChoiceBigView.h
//  PetNews
//
//  Created by 肖昶 on 13-10-13.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageDownloadedView;

@interface ChoiceBigView : UIButton{
    ImageDownloadedView* iconImageView;
    UILabel* titleLabel;
    UILabel* priceLabel;
    UILabel* shopTitleLabel;
    UIImageView* redBgView;
    UIView* lineView;

}

@property(nonatomic,assign) int index;

+(float)height;
-(void)headUrl:(NSString*)headUrl;
-(void)title:(NSString*)title;
-(void)shopTitle:(NSString*)title;
-(void)setPriceLabel:(float)price;


@end
