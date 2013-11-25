//
//  ChatMainViewController.h
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class GroupModel;

@class ChatPanel;
@class GTGZTableView;

@interface ChatMainViewController : NavContentViewController{
    GTGZTableView* tableView;
    ChatPanel* chatPanel;
    NSMutableArray*  messageArray;
    
}

@property(nonatomic,retain) GroupModel* groupModel;

@end
