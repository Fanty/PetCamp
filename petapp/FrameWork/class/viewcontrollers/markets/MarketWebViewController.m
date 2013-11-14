//
//  MarketWebViewController.m
//  PetNews
//
//  Created by fanty on 13-8-15.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "MarketWebViewController.h"
#import "GTGZThemeManager.h"
#import "DataCenter.h"
@interface MarketWebViewController ()<UIWebViewDelegate>
@end

@implementation MarketWebViewController
@synthesize updateIcon;
@synthesize url;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        [self backNavBar];
        self.navigationItem.rightBarButtonItem=nil;
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.updateIcon){
        DataCenter* dataCenter=[DataCenter sharedInstance];
        if(dataCenter.showUpdateMarket){
            dataCenter.showUpdateMarket=NO;
            [dataCenter save];
        }
    }
    

    
    
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:webView];
    [webView release];
    
    
    loadingView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame=CGRectMake(0.5f*(self.view.frame.size.width-32.0f), 0.5f*(self.view.frame.size.height-32.0f), 32.0f, 32.0f);

    [self.view addSubview:loadingView];
    [loadingView release];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.url=nil;
    [super dealloc];
}


#pragma mark method


#pragma mark webview delegate
- (void)webViewDidStartLoad:(UIWebView *)aWebView{
    [loadingView startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    [loadingView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [loadingView stopAnimating];
}


@end
