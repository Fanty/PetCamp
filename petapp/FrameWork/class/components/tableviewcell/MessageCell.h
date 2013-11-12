//
//  MessageCell.h
//  PetNews
//
//  Created by fanty on 13-8-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GTGZShadowView;
@interface MessageCell : UITableViewCell{
    
    GTGZShadowView* shadowView;
    ImageDownloadedView* headImageView;
    UILabel* titleLabel;
    UILabel* descLabel;
    UILabel* dateLabel;
    UIImageView* lineView;
    
    BOOL updateNeed;
}

-(void)headUrl:(NSString*)headUrl;
-(void)title:(NSString*)title;
-(void)content:(NSString*)content;
-(void)date:(NSDate*)date;

+(float)height;


@end
