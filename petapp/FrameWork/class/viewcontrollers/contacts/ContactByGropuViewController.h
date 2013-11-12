//
//  ContactByGropuViewController.h
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class ContactByGroupView;
@class AsyncTask;
@interface ContactByGropuViewController : NavContentViewController{
    ContactByGroupView* contactTableView;
    AsyncTask* task;
}
@property(nonatomic,retain) NSString* groupId;
@property(nonatomic,retain) NSString* uid;
@end
