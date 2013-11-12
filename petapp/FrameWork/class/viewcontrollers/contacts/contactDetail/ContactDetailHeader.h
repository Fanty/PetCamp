//
//  ContactDetailHeader.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;

@interface ContactDetailHeader : UIView{
    ImageDownloadedView* headerImage;
    UILabel* nameLabel;
    UILabel* tipLabel;
    UIImageView* sexImage;
    
    UIButton* clickButton;
}

-(void)header:(NSString*)headerUrl name:(NSString*)name tip:(NSString*)tip sex:(BOOL)sex;

-(void)setIsFriend:(BOOL)value;

@end
