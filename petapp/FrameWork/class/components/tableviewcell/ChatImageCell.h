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

@protocol ChatImageCellDelegate <NSObject>

-(void)clickDidShow:(ChatImageCell*)cell image:(UIImage*)image;
@end

@interface ChatImageCell : UITableViewCell{
    ImageDownloadedView* imageView;

    UIImageView* bubbleView;
    UILabel* nameLabel;
    ImageDownloadedView* contentImageView;
    NSBubbleType bubbleType;
    UIButton* clickButton;

}

@property(nonatomic,assign) id<ChatImageCellDelegate> delegate;

+(float)cellHeight;
-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name contentUrl:(NSString*)contentUrl  bubbleType:(NSBubbleType)bubbleType;

@end
