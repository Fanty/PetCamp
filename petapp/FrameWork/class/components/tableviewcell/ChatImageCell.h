//
//  ChatImageCell.h
//  cube-ios
//
//  Created by apple2310 on 13-9-9.
//
//

#import <UIKit/UIKit.h>
#import "ChatCell.h"


@class ChatImageCell;
@class ImageDownloadedView;

@interface ChatImageCell : UITableViewCell{
    ImageDownloadedView* imageView;

    UIImageView* bubbleView;
    UILabel* nameLabel;
    ImageDownloadedView* contentImageView;
    NSBubbleType bubbleType;

}
+(float)cellHeight;
-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name contentUrl:(NSString*)contentUrl  bubbleType:(NSBubbleType)bubbleType;

@end
