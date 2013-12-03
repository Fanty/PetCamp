//
//  GroupTextViewController.m
//  PetNews
//
//  Created by Fanty on 13-12-3.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "GroupTextViewController.h"
#import "GroupModel.h"
#import "Utils.h"
@interface GroupTextViewController ()<UITextViewDelegate>
-(void)finish;
@end

@implementation GroupTextViewController

@synthesize editDesc;
@synthesize groupModel;

-(id)init{
    self=[super init];
    if(self){
        [self backNavBar];
        
        [self rightNavBarWithTitle:lang(@"finish") target:self action:@selector(finish)];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];
    textView=[[UITextView alloc] initWithFrame:self.view.bounds];
    
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:([Utils isIPad]?25.0f:18.0f)];
    textView.backgroundColor = [UIColor clearColor];
    //textView.textColor=([Utils isIPad]?[UIColor blackColor]:[UIColor whiteColor]);
    textView.textColor=[UIColor blackColor];
    if(!self.editDesc)
        textView.text=self.groupModel.location;
    else
        textView.text=self.groupModel.desc;
    [self.view addSubview:textView];
    [textView release];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.groupModel=nil;
    [super dealloc];
}

#pragma mark  method

-(void)finish{
    if(self.editDesc)
        self.groupModel.desc=textView.text;
    else
        self.groupModel.location=textView.text;

    [self.navigationController popViewControllerAnimated:YES];
}

@end
