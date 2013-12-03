//
//  GroupTextViewController.h
//  PetNews
//
//  Created by Fanty on 13-12-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class GroupModel;
@interface GroupTextViewController : NavContentViewController{
    UITextView* textView;

}
@property(nonatomic,assign) BOOL editDesc;
@property(nonatomic,retain) GroupModel* groupModel;
@end
