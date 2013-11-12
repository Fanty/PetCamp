//
//  ImageUploaded.h
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSubUploaded : UIImageView{
    UIButton* button;
}
@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) UIImage* maxImage;
@end

@interface ImageUploaded : UIScrollView{
    UIPopoverController *popover;

    NSMutableArray* imageViews;
    
    UIButton* uploadButton;
    float left;
}

@property(nonatomic,assign) UIViewController* parentViewController;

-(void)showUpLoadButton:(BOOL)value;
-(void)smallSize;
-(NSArray*)images;
-(void)addNewImage:(UIImage*)image;
@end
