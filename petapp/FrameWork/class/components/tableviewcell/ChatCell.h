//
//  ChatCell.h
//  WeChat
//
//  Created by apple2310 on 13-9-5.
//  Copyright (c) 2013年 apple2310. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageDownloadedView;

typedef enum{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse
} NSBubbleType;

@class ImageDownloadedView;
@interface ChatCell : UITableViewCell{
    ImageDownloadedView* imageView;
    UILabel* nameLabel;
    UIImageView* bubbleView;
    UILabel* contentLabel;
    
    NSBubbleType bubbleType;
}

+(UIImage*)bubbleSomeoneImg;
+(UIImage*)bubbleMineImg;


+(float)cellHeight:(NSString*)content;
-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name content:(NSString*)content bubbleType:(NSBubbleType)bubbleType;

@end
