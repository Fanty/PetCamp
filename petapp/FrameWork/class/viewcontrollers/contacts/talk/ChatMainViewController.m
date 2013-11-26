//
//  ChatMainViewController.m
//  PetNews
//
//  Created by Fanty on 13-11-22.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "ChatMainViewController.h"
#import "GroupDetailViewController.h"
#import "ChatPanel.h"
#import "GTGZScroller.h"
#import "GTGZThemeManager.h"
#import "ChatCell.h"
#import "ChatImageCell.h"
#import "ChatModel.h"
#import "PetUser.h"
#import "DataCenter.h"
@interface ChatMainViewController ()<UITableViewDataSource,UITableViewDelegate,GTGZTouchScrollerDelegate,UIActionSheetDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,ChatPanelDelegate>

-(void)groupDetail;
@end

@implementation ChatMainViewController

@synthesize groupModel;

-(id)init{
    self=[super init];
    if(self){
        [self backNavBar];
        [self rightNavBarWithTitle:lang(@"groupDetail") target:self action:@selector(groupDetail)];
        
        chatArray=[[NSMutableArray alloc] initWithCapacity:3];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"chat_bg.png"]];
    
    
    ChatModel* model=[[ChatModel alloc] init];
    
    model.cid=@"1";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"1";
    model.petUser.nickname=@"i am abc";
    model.content=@" a";
    model.createtime=[NSDate date];
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"2";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"10";
    model.petUser.nickname=@"new pet";
    model.content=@"asdf";
    model.createtime=[NSDate date];
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"3";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"3";
    model.petUser.nickname=@"Now ok";
    model.content=@"fsoifsdjfsdoijfsjfio sfojsdoifjios jfiojsfijs iojfsoj foj\nfidjofsijfd sfosdiofjisojfiosjfojsiodf;asdfjoas;ofoijfijow;fjw;ojif;jwf o;iwejfj ;fdslfssof";
    model.createtime=[NSDate date];
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"4";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"10";
    model.petUser.nickname=@"Now ok";
    model.content=@"fsoifsdjfsdoijfsjfio sfojsdoifjios jfiojsfijs iojfsoj foj\nfidjofsijfd sfosdiofjisojfiosjfojsiodf;asdfjoas;ofoijfijow;fjw;ojif;jwf o;iwejfj ;fdslfssof";
    model.createtime=[NSDate date];
    [chatArray addObject:model];
    [model release];
    
    
    
    
    
    
    model=[[ChatModel alloc] init];
    
    model.cid=@"1";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"1";
    model.petUser.nickname=@"i am abc";
    model.content=@" a";
    model.createtime=[NSDate date];
    model.isImage=YES;
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"2";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"10";
    model.petUser.nickname=@"new pet";
    model.content=@"asdf";
    model.createtime=[NSDate date];
    model.isImage=YES;
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"3";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"3";
    model.petUser.nickname=@"Now ok";
    model.content=@"fsoifsdjfsdoijfsjfio sfojsdoifjios jfiojsfijs iojfsoj foj\nfidjofsijfd sfosdiofjisojfiosjfojsiodf;asdfjoas;ofoijfijow;fjw;ojif;jwf o;iwejfj ;fdslfssof";
    model.createtime=[NSDate date];
    model.isImage=YES;
    [chatArray addObject:model];
    [model release];
    
    
    model=[[ChatModel alloc] init];
    model.cid=@"4";
    model.petUser=[[[PetUser alloc] init] autorelease];
    model.petUser.uid=@"10";
    model.petUser.nickname=@"Now ok";
    model.content=@"fsoifsdjfsdoijfsjfio sfojsdoifjios jfiojsfijs iojfsoj foj\nfidjofsijfd sfosdiofjisojfiosjfojsiodf;asdfjoas;ofoijfijow;fjw;ojif;jwf o;iwejfj ;fdslfssof";
    model.createtime=[NSDate date];
    model.isImage=YES;
    [chatArray addObject:model];
    [model release];

    
    chatPanel=[[ChatPanel alloc] init];
    chatPanel.delegate=self;

    CGRect rect=self.view.frame;
    
    rect.size.height-=chatPanel.frame.size.height;
    
    tableView=[[GTGZTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.touchDelegate=self;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];


    chatPanel.superViewHeight=self.view.frame.size.height;
    rect=chatPanel.frame;
    rect.origin.y=self.view.frame.size.height-rect.size.height-2.0f;
    chatPanel.frame=rect;
    [self.view addSubview:chatPanel];
    [chatPanel release];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.groupModel=nil;
    [super dealloc];
}

#pragma mark method


-(void)groupDetail{
    GroupDetailViewController* controller=[[GroupDetailViewController alloc] init];
    controller.groupModel=self.groupModel;
    controller.title=self.title;
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}



#pragma mark tableview delegate  datasource

- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event{
    [chatPanel resignFirstResponder];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [chatPanel resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor=[UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [chatArray count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel* model=[chatArray objectAtIndex:[indexPath row]];
    if(model.isImage){
        return [ChatImageCell cellHeight];
    }
    else{
        return [ChatCell cellHeight:model.content];
    }
}


- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatModel* model=[chatArray objectAtIndex:[indexPath row]];

    NSString* myId=[DataCenter sharedInstance].user.uid;
    if(!model.isImage){
        ChatCell* cell=(ChatCell*)[_tableView dequeueReusableCellWithIdentifier:@"chat_cell"];
        if(cell==nil){
            cell=[[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chat_cell"];
            
            
        }
        [cell headerUrl:model.petUser.imageHeadUrl name:model.petUser.nickname content:model.content bubbleType:([myId isEqualToString:model.petUser.uid]?BubbleTypeMine:BubbleTypeSomeoneElse)];
        return cell;
    }
    else{
        ChatImageCell* cell=(ChatImageCell*)[_tableView dequeueReusableCellWithIdentifier:@"image_cell"];
        if(cell==nil){
            cell=[[ChatImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"image_cell"];
            
            
        }
        [cell headerUrl:model.petUser.imageHeadUrl name:model.petUser.nickname contentUrl:model.content bubbleType:([myId isEqualToString:model.petUser.uid]?BubbleTypeMine:BubbleTypeSomeoneElse)];
        return cell;

    }
}


-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [chatPanel resignFirstResponder];
}

#pragma mark chat panel delegate


-(void)chatPanelKeyworkShow:(int)height{
    CGRect rect= tableView.frame;
    rect.size.height=CGRectGetMinY(chatPanel.frame);
    tableView.frame=rect;
}


-(void)chatPanelDidSelectedAdd:(ChatPanel*)__chatPanel{
    [chatPanel resignFirstResponder];
    
    if([[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0){
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从手机相片图库中选取" otherButtonTitles:nil, nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self.view];
        [sheet release];
    }
    else{
        UIActionSheet* sheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相片图库中选取", nil];
        sheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self.view];
        [sheet release];

    }
}

-(void)chatPanelDidSend:(ChatPanel*)chatPanel{
    
}


#pragma mark actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==2)return;
    
    if([[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0 && buttonIndex==1)return;
    
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.videoQuality=UIImagePickerControllerQualityTypeLow;
    picker.delegate = self;
    
    if(buttonIndex==1 || [[[[UIDevice currentDevice] model] lowercaseString] rangeOfString:@"ipod"].length>0){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
            
        }
    }
    else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
            
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
        }
    }
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {

        UIPopoverController *popover = [[[UIPopoverController alloc] initWithContentViewController:picker] autorelease];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
            [picker.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        [self presentViewController:picker animated:YES completion:^{}];
        
    }
}

#pragma mark imagepicker delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popoverController.delegate=nil;
    [popoverController dismissPopoverAnimated:NO];
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popoverController.delegate=nil;
    [popoverController dismissPopoverAnimated:NO];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    picker.delegate=nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        NSString *imageKey = @"UIImagePickerControllerOriginalImage";
        UIImage* image=nil;
        image=[info objectForKey:imageKey];
        if(image!=nil && picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
        }
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker.delegate=nil;
    [picker dismissModalViewControllerAnimated:YES];
}



@end
