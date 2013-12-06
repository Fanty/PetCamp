//
//  SummaryParser.m
//  PetNews
//
//  Created by Fanty on 13-12-5.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SummaryParser.h"
#import "SummaryModel.h"

@implementation SummaryParser
- (void)onParse: (GDataXMLElement*) rootElement{
    
    NSArray* array = [rootElement nodesForXPath:@"user_summary" error:nil];

    if([array count]>0){
        GDataXMLElement* element=[array objectAtIndex:0];
        
        SummaryModel* model=[[SummaryModel alloc] init];
        
        model.fans_count=[[[element elementsForName:@"fans_count"] objectAtIndex:0] intValue];
        model.focus_count=[[[element elementsForName:@"focus_count"] objectAtIndex:0] intValue];
        model.board_count=[[[element elementsForName:@"board_count"] objectAtIndex:0] intValue];
        model.at_count=[[[element elementsForName:@"at_count"] objectAtIndex:0] intValue];

        [result release];
        result=[model retain];
        [model release];
    }
}
@end
