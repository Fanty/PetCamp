//
//  GroupDetailViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"
@class GroupModel;
@class AsyncTask;
@interface GroupDetailViewController : NavContentViewController{
    AsyncTask* task;
    
    NSMutableArray* images;

}
@property(nonatomic,retain) GroupModel* groupModel;


@end
