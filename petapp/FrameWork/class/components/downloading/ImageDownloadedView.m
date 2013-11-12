//
//  ImageDownloadedView.m
//  PetNews
//
//  Created by fanty on 13-8-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ImageDownloadedView.h"
#import "GTGZThemeManager.h"

@implementation ImageDownloadedView
@synthesize defaultLoadingfile;
-(id)init{
    self=[super init];
    self.defaultLoadingfile=@"product_image_community.png";
    self.thumbnailSize=CGSizeMake(250.0f, 250.0f);
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.defaultLoadingfile=@"product_image_community.png";
    self.thumbnailSize=CGSizeMake(250.0f, 250.0f);
    return self;
}

-(void)dealloc{
    self.defaultLoadingfile=nil;
    [super dealloc];
}

-(void)imageDownloadedStatusChanged{
    
    if(self.status!=ImageViewDownloadedStatusFinish){
        if(loadingView==nil){
            loadingView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:self.defaultLoadingfile]];
            [self addSubview:loadingView];
            [self sendSubviewToBack:loadingView];
            [loadingView release];
            loadingView.contentMode=UIViewContentModeScaleAspectFit;
        }
    }
    else{
        [loadingView removeFromSuperview];
        loadingView=nil;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    loadingView.frame=self.bounds;
}

@end
