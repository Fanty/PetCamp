//
//  MarketWebViewController.h
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "NavContentViewController.h"

@interface MarketWebViewController : NavContentViewController{
    UIWebView* webView;
    UIActivityIndicatorView* loadingView;
}

@property(nonatomic,assign) BOOL updateIcon;
@property(nonatomic,retain) NSString* url;

@end
