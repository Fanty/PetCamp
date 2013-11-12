//
//  GroupCell.h
//  PetNews
//
//  Created by fanty on 13-8-14.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@class GTGZShadowView;
@interface ContactGroupCell : UITableViewCell{
    
    ImageDownloadedView* headImageView;
    UILabel* nameLabel;
    UILabel* descLabel;
    UIImageView* lineView;
    BOOL updateNeed;
}

-(void)headUrl:(NSString*)headUrl;
-(void)name:(NSString*)name;
-(void)desc:(NSString*)desc;
+(float)height;

@end
