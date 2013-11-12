//
//  likeView.h
//  PetNews
//
//  Created by Fanty on 13-11-12.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeView : UIView{
    UIImageView* likeImageView;
    UILabel* likeLabel;
    
    UIImageView* commentImageView;
    UILabel* commentLabel;
}

-(void)like:(int)like comment:(int)comment;

@end
