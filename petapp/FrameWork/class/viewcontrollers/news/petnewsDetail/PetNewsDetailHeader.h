//
//  PetNewsDetailHeader.h
//  PetNews
//
//  Created by fanty on 13-8-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;


@interface PetNewsDetailHeader : UIView{
    ImageDownloadedView* headerImage;
    UILabel* nameLabel;

    UIImageView* commentImage;
    UILabel* commentLabel;
    UIImageView* favImage;
    UILabel* favLabel;

    
    UILabel* dateLabel;
    
    UILabel* contentLabel;
}

-(void)headerImageUrl:(NSString*)headerImageUrl name:(NSString*)name date:(NSDate*)date content:(NSString*)content comment:(int)comment favior:(int)favior;


-(void)comment:(int)comment;
-(void)favior:(int)favior;
@end
