//
//  ForwarDetailView.h
//  PetNews
//
//  Created by Fanty on 13-11-17.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageDownloadedView;
@interface ForwarDetailView : UIButton{
    ImageDownloadedView* headView;
    UILabel* nameView;
    UILabel* contentView;
}

-(void)headerUrl:(NSString*)headerUrl name:(NSString*)name content:(NSString*)content;

@end
