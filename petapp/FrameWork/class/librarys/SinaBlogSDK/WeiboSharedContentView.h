//
//  WeiboSharedContentView.h
//  PetNews
//
//  Created by fanty on 13-9-1.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboRequest;
@interface WeiboSharedContentView : UIView{
    UINavigationBar* bar;
    UITextView* textView;
    
    WeiboRequest *request;
}


-(void)sharedContent:(NSString*)content;
-(void)show;
@end
