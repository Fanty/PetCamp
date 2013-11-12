//
//  PullTableView.m
//  PetNews
//
//  Created by fanty on 13-2-26.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PullTableView.h"
#import "GTGZThemeManager.h"
#import "FooterMore.h"

@implementation PullTableView

@synthesize loadMoreState;


-(void)createLoadMoreFooter{
    if(![[self.tableFooterView class] isSubclassOfClass:[FooterMore class]]){
        FooterMore* moreView=[[FooterMore alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0)];
        moreView.userInteractionEnabled=NO;
        [moreView text:lang(@"loadmore_none")];
        self.tableFooterView = moreView;
        [moreView release];
        
    }
    loadMoreState=PullTableViewLoadMoreStateNone;
}

-(void)releaseLoadMoreFooter{
    self.tableFooterView=nil;
    loadMoreState=PullTableViewLoadMoreStateNone;
}

-(void)checkLoadMoreScrollingState{
    if(loadMoreState!=PullTableViewLoadMoreStateDragLoading && loadMoreState!=PullTableViewLoadMoreStateDragStartLoad && [[self.tableFooterView class] isSubclassOfClass:[FooterMore class]]){
        FooterMore* moreView=(FooterMore*)self.tableFooterView;
        CGPoint point =self.contentOffset;
        float h=self.contentSize.height-self.frame.size.height;
        if(point.y-h>moreView.frame.size.height*0.8f){
            self.loadMoreState=PullTableViewLoadMoreStateDragUp;
        }
        else{
            self.loadMoreState=PullTableViewLoadMoreStateNone;
        }

    }
}

-(void)setLoadMoreState:(PullTableViewLoadMoreState)value{
    loadMoreState=value;
    if([[self.tableFooterView class] isSubclassOfClass:[FooterMore class]]){
        FooterMore* moreView=(FooterMore*)self.tableFooterView;
        if(loadMoreState==PullTableViewLoadMoreStateNone){
            [moreView text:lang(@"loadmore_none")];
            [moreView loading:NO];
            [moreView arrowChange:YES animate:YES];
        }
        else if(loadMoreState==PullTableViewLoadMoreStateDragUp){
            [moreView text:lang(@"loadmore_up")];
            [moreView loading:NO];
            [moreView arrowChange:NO animate:YES];

        }
        else{
            [moreView text:lang(@"loadmore_loading")];
            [moreView loading:YES];
            [moreView arrowChange:NO animate:NO];

        }
    }
}

@end
