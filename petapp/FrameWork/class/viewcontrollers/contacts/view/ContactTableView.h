//
//  ContactTableView.h
//  PetNews
//
//  Created by fanty on 13-8-7.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"

@class ContactTableView;
@class PetUser;
@protocol ContactTableViewDelegate <NSObject>

-(void)contactTableViewDidSelect:(ContactTableView*)contactTableView user:(PetUser*)user;

@end

@interface ContactTableView : UITableView{
    NSArray *sortedKeys;
    NSMutableDictionary* dicts;
    NSMutableDictionary* showDicts;
    NSString* searchText;
}

- (id)initWithFrame:(CGRect)frame widthFans:(BOOL)fans;
@property(nonatomic,readonly) BOOL isFans;
@property(assign,nonatomic) UIViewController* parentViewController;
@property(nonatomic,assign) id<ContactTableViewDelegate> contactDelegate;
-(void)searchText:(NSString*)value;
@end
