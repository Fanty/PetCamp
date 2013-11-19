//
//  MarketTypeCell.h
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;

@interface MarketTypeCell : UITableViewCell{
    ImageDownloadedView* headImageView;
    UILabel* titleLabel;
    UILabel* descLabel;

    UIImageView* lineView;
}
+(float)height;
-(void)headerUrl:(NSString*)headerUrl title:(NSString*)title desc:(NSString*)desc;

@end
