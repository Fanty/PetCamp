//
//  FooterMore.h
//  PetNews
//
//  Created by fanty on 13-1-25.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterMore : UIButton{
    UIImageView* arrowView;
    UILabel* moreLabel;
    UIActivityIndicatorView* loadingView;
}

@property(nonatomic,retain) NSString* themeKey;

-(void)text:(NSString*)value;

-(void)loading:(BOOL)value;
-(BOOL)loading;

-(void)indicatorViewStyle:(UIActivityIndicatorViewStyle)style;

-(void)arrowChange:(BOOL)down animate:(BOOL)animate;

@end
