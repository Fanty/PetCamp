//
//  GTGZImageDownloadedView.h
//  GTGZLibrary
//
//  Created by fanty on 13-4-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum _ImageViewDownloadedStatus {
	ImageViewDownloadedStatusNone = 0,
    ImageViewDownloadedStatusDownloading,
    ImageViewDownloadedStatusFinish,
    ImageViewDownloadedStatusFail,
} ImageViewDownloadedStatus;


@interface GTGZImageDownloadedView : UIImageView{
    ImageViewDownloadedStatus status;

}

@property(nonatomic,retain) NSString* url;
@property(nonatomic,assign) CGSize thumbnailSize;
@property(nonatomic,readonly) ImageViewDownloadedStatus status;

-(void)imageDownloadedStatusChanged;
@end
