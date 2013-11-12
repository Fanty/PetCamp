//
//  ContactTableView.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@class AsyncTask;

@interface ContactTableView : PullTableView{
    NSArray *sortedKeys;
    NSMutableDictionary* dicts;
    NSMutableDictionary* showDicts;

    AsyncTask* task;
    
    NSString* searchText;

}
@property(assign,nonatomic) UIViewController* parentViewController;

-(void)clear;

-(void)loadData;

-(void)searchText:(NSString*)value;
@end
