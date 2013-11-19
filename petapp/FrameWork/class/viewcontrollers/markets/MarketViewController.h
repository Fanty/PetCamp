//
//  MarketViewController.h
//  PetNews
//
//  Created by fanty on 13-8-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@class MarketTableView;
@interface MarketViewController : NavContentViewController{

    
    
    MarketTableView*  markerTableView;

}

@property(nonatomic,retain) NSString* type_id;


@end
