//
//  CreateGroupViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CreateGroupViewController{
    UITableView* tableView;
    
    NSArray* array;
}

- (id)init{
    self = [super init];
    if (self) {
        [self backNavBar];
        
        array=[[NSArray arrayWithObjects:lang(@"groupName"),lang(@"groupHost"), lang(@"groupDescription"),nil] retain];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    
    [self.view addSubview:tableView];
    [tableView release];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [array release];
    [super dealloc];
}

#pragma mark tableview delegate  datasource

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    return cell;
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
