//
//  ContactCell.h
//  PetNews
//
//  Created by fanty on 13-8-8.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GTGZShadowView;
@interface ContactCell : UITableViewCell{
    
    GTGZShadowView* shadowView;
    ImageDownloadedView* headImageView;
    UILabel* nameLabel;
    UILabel* descLabel;
    UILabel* smallTipLabel;
    UIImageView* sexImageView;    
    UIImageView* lineView;
    
    BOOL updateNeed;
}

-(void)headUrl:(NSString*)headUrl;
-(void)name:(NSString*)name;
-(void)desc:(NSString*)desc;
-(void)tip:(NSString*)tip;
-(void)sex:(BOOL)sex;
+(float)height;


@end


