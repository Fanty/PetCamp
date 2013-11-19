//
//  NoCell.h
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoCell : UITableViewCell{
    UIImageView* lineView;
    
    UIActivityIndicatorView* loading;

}

-(void)showLoading:(BOOL)value;

@end
