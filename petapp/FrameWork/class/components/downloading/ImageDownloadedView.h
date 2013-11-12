//
//  ImageDownloadedView.h
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GTGZImageDownloadedView.h"

@interface ImageDownloadedView : GTGZImageDownloadedView{
    UIImageView* loadingView;
}

@property(nonatomic,retain) NSString* defaultLoadingfile;

@end
