//
//  ChoiceTableCell.h
//  PetNews
//
//  Created by Grace Lai on 6/8/13.
//  Copyright (c) 2013 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageDownloadedView;
@interface ChoiceTableCell : UITableViewCell{

    ImageDownloadedView* iconImageView;
    UILabel* titleLabel;
    UILabel* priceLabel;
    UILabel* shopTitleLabel;
    
    BOOL updateNeed;

}

+(float)height;
-(void)headUrl:(NSString*)headUrl;
-(void)title:(NSString*)title;
-(void)shopTitle:(NSString*)title;
-(void)setPriceLabel:(float)price;

@end
