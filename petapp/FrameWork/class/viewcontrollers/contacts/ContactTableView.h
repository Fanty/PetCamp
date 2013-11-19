//
//  ContactTableView.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@interface ContactTableView : UITableView{
    NSArray *sortedKeys;
    NSMutableDictionary* dicts;
    NSMutableDictionary* showDicts;
    NSString* searchText;
}
@property(assign,nonatomic) UIViewController* parentViewController;

-(void)searchText:(NSString*)value;
@end
