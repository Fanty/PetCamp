//
//  CommandCell.h
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageDownloadedView;

@interface CommandCell : UITableViewCell{

    UIView* bgView;
    ImageDownloadedView* headerImage;
    UILabel* nameLabel;
    UILabel* dateLabel;
    
    UILabel* contentLabel;
    
    UIImageView* lineView;
    
    BOOL isLayoutUpdate;
}

-(void)nickname:(NSString*)nickname headerImageUrl:(NSString*)headerImageUrl content:(NSString*)content date:(NSDate*)date;

+(float)cellHeight;

@end
