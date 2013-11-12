//
//  EditedViewController.h
//  PetNews
//
//  Created by fanty on 13-8-29.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "BaseViewController.h"
@class EditedViewController;
@protocol EditedViewControllerDelegate <NSObject>

-(void)editedFinish:(EditedViewController*)controller text:(NSString*)text;

@end

@interface EditedViewController : BaseViewController{
    UITextView* textView;

}
@property(nonatomic,retain) NSString* text;
@property(nonatomic,assign) id<EditedViewControllerDelegate> delegate;

@end
