//
//  PetNewsEditViewController.m
//  PetNews
//
//  Created by fanty on 13-8-20.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "PetNewsEditViewController.h"
#import "GTGZThemeManager.h"
#import "EditerView.h"
#import "AppDelegate.h"
#import "PetUser.h"
#import "ImageDownloadedView.h"
#import "AsyncTask.h"
#import "GTGZUtils.h"
#import "ImageUploaded.h"
#import "PetNewsAndActivatyManager.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "SettingManager.h"
#import "DataCenter.h"
#import "PetNewsNavigationController.h"
#import "WeiboAddViewController.h"
#import "Utils.h"
@interface PetNewsEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditerViewDelegate,UIPopoverControllerDelegate,WeiboAddViewControllerDelegate,UITextViewDelegate>

@property(nonatomic,retain) NSString* content;


-(void)goBack;
-(void)send;
-(void)keyboardWillShow:(NSNotification *)note;
-(void)keyboardWillHide:(NSNotification *)note;
-(void)uploadImage;
-(void)createPetNews;

@end

@implementation PetNewsEditViewController
@synthesize content;
-(id)init{
    self=[super init];
    if(self){
        [self leftNavBar:@"back_header.png" target:self action:@selector(goBack)];
        [self rightNavBarWithTitle:lang(@"send") target:self action:@selector(send)];

        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    imageQueue=0;
    [imageLinks release];
    imageLinks=[[NSMutableString alloc] init];

    
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];

    
    if([Utils isIPad])
        imageDownloaded=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 100.0f, 100.0f)];
    else
        imageDownloaded=[[ImageDownloadedView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
    [imageDownloaded setUrl:[DataCenter sharedInstance].user.imageHeadUrl];
    [self.view addSubview:imageDownloaded];
    [imageDownloaded release];
    
    textView=[[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageDownloaded.frame)+5.0f,10.0f, self.view.frame.size.width-CGRectGetMaxX(imageDownloaded.frame)-10.0f, 180.0f)];
    textView.delegate=self;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:([Utils isIPad]?25.0f:18.0f)];
    textView.backgroundColor = [UIColor clearColor];
   // textView.textColor=([Utils isIPad]?[UIColor blackColor]:[UIColor whiteColor]);
    textView.textColor=[UIColor blackColor];
    [self.view addSubview:textView];
    [textView release];
    
    imageUploaded=[[ImageUploaded alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0)];
    [imageUploaded smallSize];
    [imageUploaded showUpLoadButton:NO];
    [self.view addSubview:imageUploaded];
    [imageUploaded release];

    
    editerView=[[EditerView alloc] init];
    editerView.delegate=self;
    CGRect rect=editerView.frame;
    rect.origin.y=self.view.frame.size.height;
    editerView.frame=rect;
    [self.view addSubview:editerView];
    [editerView release];

    
    fgView=[[UIView alloc] initWithFrame:self.view.bounds];
    
    fgView.userInteractionEnabled=NO;
    [self.view addSubview:fgView];
    [fgView release];
}

-(void)dealloc{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    [task cancel];
    [loadingHud hide:YES];
    self.content=nil;
    [imageLinks release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;

    [loadingHud hide:YES];
    loadingHud=nil;
    [task cancel];
    task=nil;
    self.content=nil;
    [imageLinks release];
    imageLinks=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [textView becomeFirstResponder];
    self.title=[DataCenter sharedInstance].user.nickname;

}

#pragma mark method

-(void)goBack{
    if(task==nil){
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)send{
    if(task!=nil)return;
    [textView resignFirstResponder];
    imageQueue=0;
    [task cancel];
    task=nil;
    [loadingHud hide:YES];
    loadingHud=nil;
    [imageLinks release];
    imageLinks=[[NSMutableString alloc] init];
    self.content=[GTGZUtils trim:textView.text];
    if([self.content length]<1){
        return;
    }
    
    loadingHud=[AlertUtils showLoading:lang(@"loadmore_loading") view:fgView];
    [loadingHud show:NO];
    [self uploadImage];

    
}

-(void)uploadImage{
    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    [task cancel];
    NSArray* images=[imageUploaded images];
    if(imageQueue<[images count]){
        UIImage* img=[images objectAtIndex:imageQueue];
        img=[GTGZUtils imageWithThumbnail:img size:CGSizeMake(480.0f, 640.0f)];
        NSData* data=UIImageJPEGRepresentation(img, 90);
        
        task=[[AppDelegate appDelegate].settingManager fileUpload:data type:@"activaty"];
        [task setFinishBlock:^{
            
            if([task result]!=nil){
                NSString* link=[task result];
                if([link length]>0){
                    [imageLinks appendString:link];
                    if(imageQueue<[images count]-1)
                        [imageLinks appendString:@","];
                }
            }
            
            imageQueue++;
            task=nil;
            [self uploadImage];
        }];
    }
    else{
        [self createPetNews];
    }
    [pool release];
}

-(void)createPetNews{
    [task cancel];
    task=[[AppDelegate appDelegate].petNewsAndActivatyManager createPetNews:self.content images:imageLinks src_post_id:nil];
    [task setFinishBlock:^{
        [loadingHud hide:YES];
        loadingHud=nil;

        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:fgView];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdatePetNewsListNotification object:nil];
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
        task=nil;
    }];
}


#pragma mark notification

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    

    
    float newHeight=self.view.bounds.size.height-keyboardBounds.size.height;
    
    CGRect editerFrame=editerView.frame;
    editerFrame.origin.y=newHeight-editerFrame.size.height;

    
    CGRect uploadFrame=imageUploaded.frame;
    uploadFrame.origin.y=editerFrame.origin.y-uploadFrame.size.height;
    
    CGRect textViewFrame=textView.frame;
    textViewFrame.origin.y=10.0f;
    textViewFrame.size.height=uploadFrame.origin.y-15.0f;

    

    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	editerView.frame=editerFrame;
    imageUploaded.frame=uploadFrame;
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    

    CGRect editerFrame=editerView.frame;
    editerFrame.origin.y=self.view.bounds.size.height-editerFrame.size.height;
    
    CGRect uploadFrame=imageUploaded.frame;
    uploadFrame.origin.y=editerFrame.origin.y-uploadFrame.size.height;
    
    CGRect textViewFrame=textView.frame;
    textViewFrame.origin.y=10.0f;
    textViewFrame.size.height=uploadFrame.origin.y-15.0f;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	editerView.frame=editerFrame;
    imageUploaded.frame=uploadFrame;
    textView.frame=textViewFrame;
    
	[UIView commitAnimations];

}


#pragma mark weiboaddviewcontroller delegate

-(void)weiboAddViewController:(WeiboAddViewController *)viewController nickname:(NSString *)nickname{
    textView.text=[textView.text stringByReplacingCharactersInRange:textView.selectedRange withString:[NSString stringWithFormat:@" %@ ",nickname]];
}

-(void)weiboAddViewControllerCancel:(WeiboAddViewController *)viewController{
    textView.text=[textView.text stringByReplacingCharactersInRange:textView.selectedRange withString:@"@"];

}

#pragma mark editer delegate

-(void)editerClick:(EditerView *)editerView click:(int)index{
        
    if(index==0 || index==1){
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.videoQuality=UIImagePickerControllerQualityTypeHigh;
        picker.delegate = self;
        
        if(index==1){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                picker.mediaTypes = temp_MediaTypes;
                
            }
        }
        else{            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;                
                NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                picker.mediaTypes = temp_MediaTypes;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                
            }
        }
        
        if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
            popover.delegate=nil;
            [popover dismissPopoverAnimated:NO];
            popover=nil;
            popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
                [picker.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            }
            popover.delegate=self;
            [popover presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//            [popover release];
        }
        else{
            [self presentModalViewController:picker animated:YES];
        }
        
    }
    else if(index==2){
        WeiboAddViewController* controller=[[WeiboAddViewController alloc] init];
        controller.delegate=self;
        PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
        [controller release];

        [self presentModalViewController:navController animated:YES];
        [navController release];
    }
}

#pragma mark imagePicker Delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        picker.delegate=nil;
        [picker dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    picker.delegate=nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"] || [mediaType isEqualToString:@"public.movie"]){
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        NSString *imageKey = @"UIImagePickerControllerOriginalImage";
        UIImage* image=nil;
        if([mediaType isEqualToString:@"public.image"]){
            image=[info objectForKey:imageKey];
            if(image!=nil && picker.sourceType==UIImagePickerControllerSourceTypeCamera){
                UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
            }
            
            [imageUploaded addNewImage:image];
//            NSData* imageData= UIImageJPEGRepresentation(image, 1.0f);
//            [imageData writeToFile:[SCMPPathUtils tempIScoopUploadPath] atomically:YES];
            
        }
        [pool release];
    }
    
    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        [picker dismissModalViewControllerAnimated:YES];
    }
    
}

#pragma mark textview delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"@"]){
        WeiboAddViewController* controller=[[WeiboAddViewController alloc] init];
        controller.delegate=self;
        PetNewsNavigationController* navController=[[PetNewsNavigationController alloc] initWithRootViewController:controller];
        [controller release];
        
        [self presentModalViewController:navController animated:YES];
        [navController release];

        return NO;
    }
    return YES;
}


@end
