//
//  NoCell.m
//  PetNews
//
//  Created by apple2310 on 13-9-6.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NoCell.h"
#import "GTGZThemeManager.h"
#import "Utils.h"

@implementation NoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        self.accessoryType=UITableViewCellAccessoryNone;
        self.textLabel.text=lang(@"failCell");

        self.textLabel.textColor=[UIColor blackColor];

        if([Utils isIPad]){
            self.textLabel.font=[UIFont systemFontOfSize:22.0f];
        }
        else{
//            self.textLabel.textColor=[UIColor whiteColor];
            self.textLabel.font=[UIFont systemFontOfSize:16.0f];
        }
        lineView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageByTheme:@"h_line.png"]];
        [self addSubview:lineView];
        [lineView release];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect=lineView.frame;
    rect.size.width=self.frame.size.width;
    rect.origin.y=self.frame.size.height-rect.size.height;
    lineView.frame=rect;
    if(loading!=nil){
        rect=loading.frame;
        CGSize size=[self.textLabel.text sizeWithFont:self.textLabel.font];
        rect.origin.x=size.width*1.5f;
        rect.origin.y=(self.frame.size.height-rect.size.height)*0.5f;
        loading.frame=rect;
    }
}

-(void)showLoading:(BOOL)value{
    if(value){
        if(loading==nil){
            loading=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            loading.color=[UIColor blackColor];
            [self addSubview:loading];
            [loading release];
            
            [loading startAnimating];
        }
        self.textLabel.text=lang(@"loading");

    }
    else{
        self.textLabel.text=lang(@"clickfailed");

        [loading stopAnimating];
        [loading removeFromSuperview];
        loading=nil;
    }
}

@end
