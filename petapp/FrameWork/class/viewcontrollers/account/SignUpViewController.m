//
//  SignUpViewController.m
//  PetNews
//
//  Created by fanty on 13-8-2.
//  Copyright (c) 2013年 fanty. All rights reserved.
//

#import "SignUpViewController.h"
#import "PetNewsNavigationController.h"
#import "CheckBoxView.h"
#import "AreaModel.h"
#import "TextInputView.h"
#import "GTGZThemeManager.h"
#import "PathUtils.h"
#import "AppDelegate.h"
#import "SettingManager.h"
#import "AsyncTask.h"
#import "AccountManager.h"
#import "AlertUtils.h"
#import "MBProgressHUD.h"
#import "GTGZUtils.h"
#import "PetUser.h"
#import "ServiceWebViewController.h"
#import "Utils.h"
#import "GTGZScroller.h"
typedef enum{
    SignUpViewControllerSelectedNone=0,
    SignUpViewControllerSelectedTypeSex,
    SignUpViewControllerSelectedTypeProvince,
    SignUpViewControllerSelectedTypeCity,
    SignUpViewControllerSelectedTypeArea,
    SignUpViewControllerSelectedTypePetType,
    SignUpViewControllerSelectedTypePetSex
}SignUpViewControllerSelectedType;
@interface SignUpViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIPopoverControllerDelegate,GTGZTouchScrollerDelegate,UIScrollViewDelegate>
-(void)showPicker:(int)index;
-(void)hidePicker;
-(void)imageClick;
-(void)sexClick;
-(void)provinceClick;
-(void)cityClick;
-(void)areaClick;
-(void)petTypeClick;
-(void)petSexClick;
-(void)confirmClick;

-(void)doUploadFile;
-(void)doRegister:(NSString*)imageLink;

@property(nonatomic,assign) SignUpViewControllerSelectedType  selectedType;
@end

@implementation SignUpViewController
@synthesize selectedType;
-(id)init{
    self=[super init];
    if(self){
        self.title = lang(@"info");
        [self backNavBar];
    
        selectedSex=-1;
        selectedPetSex=-1;
        selectedPetType=-1;
        selectedProvince=-1;
        selectedCity=-1;
        selectedArea=-1;

        areaArray=[[[AppDelegate appDelegate].settingManager countryList] retain];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame=self.view.frame;
    frame.size.height-=44.0f;
    self.view.frame=frame;
    
    scrollView=[[GTGZScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.touchDelegate=self;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [scrollView release];
    
   // self.view.backgroundColor=[UIColor colorWithPatternImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"bg.png"]];
    
    float offset=([Utils isIPad]?30.0f:10.0f);
    float leftoffset=([Utils isIPad]?130.0f:30.0f);
    float w=frame.size.width-leftoffset*2.0f;
    float h=([Utils isIPad]?80.0f:44.0f);
    float minoffset=([Utils isIPad]?7.0f:2.0f);
    
    UIImage* headImage=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"signup_header.png"];

    headerImageView=[UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageView setImage:headImage forState:UIControlStateNormal];
    CGRect rect=headerImageView.frame;
    rect.size=headImage.size;
    rect.origin.x=(frame.size.width-rect.size.width)*0.5f;
    rect.origin.y=offset;
    headerImageView.frame=rect;
    [scrollView addSubview:headerImageView];
    [headerImageView addTarget:self action:@selector(imageClick) forControlEvents:UIControlEventTouchUpInside];

    
    nicknameField=[[TextInputView alloc] initWithTitle:lang(@"userName") field:@""];
    nicknameField.frame=CGRectMake(leftoffset, CGRectGetMaxY(headerImageView.frame)+offset, w, h);
    [nicknameField delegate:self];
    [nicknameField returnKeyType:UIReturnKeyNext];
    [scrollView addSubview:nicknameField];
    [nicknameField release];

    phoneField=[[TextInputView alloc] initWithTitle:lang(@"mobileNum") field:@""];
    [phoneField delegate:self];
    phoneField.frame=CGRectMake(leftoffset, CGRectGetMaxY(nicknameField.frame)+minoffset, w, h);
    [phoneField returnKeyType:UIReturnKeyNext];
    [phoneField keyboardType:UIKeyboardTypePhonePad];
    [scrollView addSubview:phoneField];
    [phoneField release];
    
    passwordField=[[TextInputView alloc] initWithTitle:lang(@"loginpassword") field:@""];
    [passwordField delegate:self];
    [passwordField secureTextEntry:YES];
    passwordField.frame=CGRectMake(leftoffset, CGRectGetMaxY(phoneField.frame)+minoffset, w, h);
    [passwordField returnKeyType:UIReturnKeyNext];
    [scrollView addSubview:passwordField];
    [passwordField release];
    
    emailField=[[TextInputView alloc] initWithTitle:lang(@"email") field:@""];
    [emailField delegate:self];
    emailField.frame=CGRectMake(leftoffset, CGRectGetMaxY(passwordField.frame)+minoffset, w, h);
    [emailField returnKeyType:UIReturnKeyNext];
    [emailField keyboardType:UIKeyboardTypeEmailAddress];
    [scrollView addSubview:emailField];
    [emailField release];


    
    personDescField=[[TextInputView alloc] initWithTitle:lang(@"inputpersondes") field:@""];
    [personDescField delegate:self];
    [personDescField returnKeyType:UIReturnKeyDone];
    
    personDescField.frame=CGRectMake(leftoffset, CGRectGetMaxY(emailField.frame)+minoffset, w, h);
    [scrollView addSubview:personDescField];
    [personDescField release];
    
    
    sexField=[[TextInputView alloc] initWithTitle:lang(@"user_sex") field:@""];
    [sexField textFieldDisabled];
    [sexField showArrow];
    sexField.frame=CGRectMake(leftoffset, CGRectGetMaxY(personDescField.frame)+minoffset, w, h);
    [scrollView addSubview:sexField];
    [sexField release];
    [sexField addTarget:self action:@selector(sexClick) forControlEvents:UIControlEventTouchUpInside];

    
    float minW = w/3;
    
    UIImage* img=[[GTGZThemeManager sharedInstance] imageByTheme:@"board.png"];
    img=[img stretchableImageWithLeftCapWidth:img.size.width*0.5f topCapHeight:img.size.height*0.5f];

    areaBGView=[[UIImageView alloc] initWithImage:img];
    areaBGView.frame=CGRectMake(leftoffset, CGRectGetMaxY(sexField.frame)+offset, w, h);
    areaBGView.userInteractionEnabled=YES;
    [scrollView addSubview:areaBGView];
    [areaBGView release];
    
    
    AreaModel* provinceModel=selectedProvince>-1?[areaArray objectAtIndex:selectedProvince]:nil;
    
    provinceField=[[TextInputView alloc] initWithTitle:lang(@"province") value:provinceModel.name];
    provinceField.frame=CGRectMake(0.0f, 0.0f, minW, h);
    [areaBGView addSubview:provinceField];
    [provinceField release];
    [provinceField addTarget:self action:@selector(provinceClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* lineView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(provinceField.frame), 4.0f, 2.0f, h-8.0f)];
    lineView.backgroundColor=[UIColor grayColor];
    lineView.alpha=0.5f;
    [areaBGView addSubview:lineView];
    [lineView release];


    AreaModel* cityModel=selectedCity>-1?[provinceModel.list objectAtIndex:selectedCity]:nil;
    cityField=[[TextInputView alloc] initWithTitle:lang(@"city") value:cityModel.name];
    cityField.frame=CGRectMake(CGRectGetMaxX(provinceField.frame), 0.0f, minW, h);
    [areaBGView addSubview:cityField];
    [cityField release];
    [cityField addTarget:self action:@selector(cityClick) forControlEvents:UIControlEventTouchUpInside];
    
    lineView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityField.frame), 4.0f, 2.0f, h-8.0f)];
    lineView.backgroundColor=[UIColor grayColor];
    lineView.alpha=0.5f;
    [areaBGView addSubview:lineView];
    [lineView release];


    AreaModel* areaModel=selectedArea>-1?[cityModel.list objectAtIndex:selectedArea]:nil;
    areaField=[[TextInputView alloc] initWithTitle:lang(@"area") value:areaModel.name];
    areaField.frame=CGRectMake(CGRectGetMaxX(cityField.frame), 0.0f, minW, h);
    [areaBGView addSubview:areaField];
    [areaField release];
    [areaField addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];

    
    petTypeField=[[TextInputView alloc] initWithTitle:lang(@"pet_type") field:@""];
    [petTypeField textFieldDisabled];
    [petTypeField showArrow];
    petTypeField.frame=CGRectMake(leftoffset, CGRectGetMaxY(areaBGView.frame)+offset, w, h);
    [scrollView addSubview:petTypeField];
    [petTypeField release];
    [petTypeField addTarget:self action:@selector(petTypeClick) forControlEvents:UIControlEventTouchUpInside];

    
    petSexField=[[TextInputView alloc] initWithTitle:lang(@"pet_sex") field:@""];
    [petSexField textFieldDisabled];
    [petSexField showArrow];
    petSexField.frame=CGRectMake(leftoffset, CGRectGetMaxY(petTypeField.frame)+minoffset, w, h);
    [scrollView addSubview:petSexField];
    [petSexField release];
    [petSexField addTarget:self action:@selector(petSexClick) forControlEvents:UIControlEventTouchUpInside];


    img=[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"registerbutton.png"];
    confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setBackgroundImage:img forState:UIControlStateNormal];
    [confirmButton setTitle:lang(@"confirm") forState:UIControlStateNormal];
    rect=confirmButton.frame;
    rect.origin.x=leftoffset;
    rect.origin.y=CGRectGetMaxY(petSexField.frame)+offset;
    rect.size.width=w;
    rect.size.height=img.size.height*2.0f;
    confirmButton.frame=rect;

    /*
    if([Utils isIPad]){
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:35.0f]];
    }
     */
    
    [scrollView addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];

    logoView=[[UIImageView alloc] initWithImage:[[GTGZThemeManager sharedInstance] imageResourceByTheme:@"petlogo.png"]];
    rect=logoView.frame;
    rect.origin.y=CGRectGetMaxY(confirmButton.frame)+offset*2.0f;
    rect.origin.x=(self.view.frame.size.width-rect.size.width)*0.5f;
    logoView.frame=rect;
    [scrollView addSubview:logoView];
    [logoView release];

    
    logoLabel=[[UIWebView alloc] initWithFrame:CGRectMake(leftoffset, CGRectGetMaxY(logoView.frame)+2, w, 80.0f)];
    
    logoLabel.backgroundColor=[UIColor clearColor];
    logoLabel.scalesPageToFit=NO;
    logoLabel.delegate=self;
    logoLabel.opaque=NO;
    if([Utils isIPad]){
        [logoLabel loadHTMLString:@"<html><body style=\"background-color:Transparent;margin:0;padding:0;\"><div style=\"font-size:18px;color:black;font-family:Arial;\">通过登录，即表示我可接受Petcamp的<a href=\"terms\" style=\"color:Black\"> 服务条款</a>和<a href=\"privacy\" style=\"color:Black\">隐私政策</a>.</div></body></html>" baseURL:nil];

    }
    else{
        [logoLabel loadHTMLString:@"<html><body style=\"background-color:Transparent;margin:0;padding:0;\"><div style=\"font-size:13px;color:gray;font-family:Arial;\">通过登录，即表示我可接受Petcamp的<a href=\"terms\" style=\"color:Black\"> 服务条款</a>和<a href=\"privacy\" style=\"color:Black\">隐私政策</a>.</div></body></html>" baseURL:nil];
        
    }
    for(id view in logoLabel.subviews){
        if([[view class] isSubclassOfClass:[UIScrollView class]]){
            ((UIScrollView *)view).scrollEnabled=NO;
            break;
        }
        
    }
    [scrollView addSubview:logoLabel];
    [logoLabel release];
    
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(logoLabel.frame));
    
    
    pickerBgView=[[UIView alloc] initWithFrame:self.view.bounds];
    pickerBgView.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    pickerBgView.userInteractionEnabled=YES;
    pickerBgView.hidden=YES;
    [self.view addSubview:pickerBgView];
    [pickerBgView release];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, pickerBgView.frame.size.height, pickerBgView.frame.size.width, 216.0)];
    
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [pickerBgView addSubview:picker];
    [picker release];

}

-(void)dealloc{
    popover.delegate=nil;
    [popover dismissPopoverAnimated:NO];
    [popover release];
    popover=nil;
    [task cancel];
    [areaArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark method

-(BOOL)canBackNav{
    return (task==nil);
}

-(void)showPicker:(int)index{
    [nicknameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    [personDescField resignFirstResponder];

    [picker reloadAllComponents];
    [picker selectRow:index inComponent:0 animated:YES];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        pickerBgView.hidden=NO;
        CGRect rect=picker.frame;
        rect.origin.y=pickerBgView.frame.size.height-rect.size.height;
        picker.frame=rect;
        
        rect=self.view.frame;
        rect.origin.y=0.0f;
        self.view.frame=rect;

    } completion:^(BOOL finish){
        
    }];
}

-(void)hidePicker{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect=picker.frame;
        rect.origin.y=pickerBgView.frame.size.height;
        picker.frame=rect;
    } completion:^(BOOL finish){
        pickerBgView.hidden=YES;        
    }];

}

-(void)imageClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:lang(@"cancel") destructiveButtonTitle:lang(@"camera") otherButtonTitles:lang(@"open_phone"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];

}

-(void)sexClick{
    self.selectedType=SignUpViewControllerSelectedTypeSex;
    if(selectedSex<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }
    [self showPicker:selectedSex];
}

-(void)provinceClick{
    self.selectedType=SignUpViewControllerSelectedTypeProvince;
    if(selectedProvince<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }

    [self showPicker:selectedProvince];

}

-(void)cityClick{
    if(selectedProvince<0)return;
    self.selectedType=SignUpViewControllerSelectedTypeCity;
    if(selectedCity<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }

    [self showPicker:selectedCity];

}

-(void)areaClick{
    if(selectedCity<0)return;
    self.selectedType=SignUpViewControllerSelectedTypeArea;
    if(selectedArea<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }

    [self showPicker:selectedArea];

}

-(void)petTypeClick{
    self.selectedType=SignUpViewControllerSelectedTypePetType;
    if(selectedPetType<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }

    [self showPicker:selectedPetType];

}

-(void)petSexClick{
    self.selectedType=SignUpViewControllerSelectedTypePetSex;
    if(selectedPetSex<0){
        [self pickerView:picker didSelectRow:0 inComponent:0];
    }

    [self showPicker:selectedPetSex];

}

-(void)confirmClick{

    
    NSString* msg = nil;
    
    
    if([nicknameField content].length < 1){
        msg = lang(@"nickNameMsg");
    }
    else if([phoneField content].length < 1){
        
        msg = lang(@"mobileEmpty");
    }
    else if([passwordField content].length < 1){
        
        msg = lang(@"passwordEmpty");
    }
    else if([emailField content].length < 1){
        msg = lang(@"emailMsg");
    }
    else if(![GTGZUtils isValidateEmail:[emailField content]]){
        msg = lang(@"emailMsg2");
    }
    else if(selectedSex == -1){
        msg = lang(@"pls_gender");
    }
    else if(selectedPetType == -1){
        msg = lang(@"pls_petType");
    }
    else if(selectedPetSex == -1){
        msg = lang(@"petGenderMsg");
    }
    
    
    if(msg != nil || msg.length > 1){

        [hud hide:NO];
        hud=nil;
        [AlertUtils showAlert:msg view:self.view];
        return;
    }
    
    [hud hide:NO];
    hud=[AlertUtils showLoading:lang(@"loading") view:self.view];
    [hud show:NO];
    [self doUploadFile];
}

-(void)doUploadFile{
    if(!isSelectedImage){
        [self doRegister:@""];
    }
    else{
        [task cancel];
        UIImage* img=headerImageView.imageView.image;
        img=[GTGZUtils imageWithThumbnail:img size:CGSizeMake(150.0f, 150.0f)];
        NSData* data=UIImageJPEGRepresentation(img, 90);

        task=[[AppDelegate appDelegate].settingManager fileUpload:data type:@"user"];
        [task setFinishBlock:^{
            NSString* link=@"";
            if([task result]!=nil){
                link=[task result];
            }
            task=nil;

            if([link length]>0){
                [self doRegister:link];
            }
            else{
                [hud hide:NO];
                hud=nil;
                [AlertUtils showAlert:lang(@"fileUploadFailed") view:self.view];
            }
        }];
    }
}

-(void)doRegister:(NSString*)imageLink{
    [task cancel];
    PetUser* petUser=[[PetUser alloc] init];
    petUser.nickname=[GTGZUtils trim:[nicknameField content]];
    petUser.bind_phone=[GTGZUtils trim:[phoneField content]];
    petUser.password=[GTGZUtils trim:[passwordField content]];
    petUser.bind_email=[GTGZUtils trim:[emailField content]];
    petUser.imageHeadUrl=imageLink;
    petUser.sex=(selectedSex==0);
    petUser.person_desc=[GTGZUtils trim:[personDescField content]];
    petUser.province=[GTGZUtils trim:[provinceField content]];
    petUser.city=[GTGZUtils trim:[cityField content]];
    petUser.area=[GTGZUtils trim:[areaField content]];

    if(selectedPetType==0)
        petUser.petType=PetUserPetTypeDog;
    else if(selectedPetType==1)
        petUser.petType=PetUserPetTypeCat;
    else
        petUser.petType=PetUserPetTypeOther;
    petUser.pet_sex=(selectedPetSex==0);
    
    task=[[AppDelegate appDelegate].accountManager signup:petUser password:[passwordField content]];
    [task setFinishBlock:^{
        [hud hide:YES];
        hud=nil;
        if(![task status]){
            [AlertUtils showAlert:[task errorMessage] view:self.view];
        }
        else{
            UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:lang(@"registerSuccess") message:@"" delegate:self cancelButtonTitle:lang(@"confirm") otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        task=nil;
    }];
    [petUser release];
}



#pragma mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.view.frame;
        if([textField.superview isEqual:emailField] || [textField.superview isEqual:personDescField]){
            rect.origin.y=-80.0f;
        }
        else{
            rect.origin.y=0.0f;
        }
        self.view.frame=rect;
    } completion:^(BOOL finish){
    
    }];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* text=[textField.text stringByReplacingCharactersInRange:range withString:string];
    TextInputView* inputText=(TextInputView*)textField.superview;
    [inputText updateTitleColor:text];
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.superview isEqual:nicknameField]){
        [phoneField becomeFirstResponder];
    }
    else if([textField.superview isEqual:phoneField]){
        [passwordField becomeFirstResponder];
    }
    else if([textField.superview isEqual:passwordField]){
        [emailField becomeFirstResponder];
    }
    else if([textField.superview isEqual:emailField]){
        [personDescField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];

        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect rect=self.view.frame;
            rect.origin.y=0.0f;
            self.view.frame=rect;
        } completion:^(BOOL finish){
            
        }];
    }
    return YES;

}

#pragma mark picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

//返回指定列的行数
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.selectedType==SignUpViewControllerSelectedTypeSex || self.selectedType==SignUpViewControllerSelectedTypePetSex)
        return 2;
    else if(self.selectedType==SignUpViewControllerSelectedTypePetType)
        return 3;
    else if(self.selectedType==SignUpViewControllerSelectedTypeProvince)
        return [areaArray count];
    else if(self.selectedType==SignUpViewControllerSelectedTypeCity){
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        return [model.list count];
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeArea){
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        AreaModel* model2=[model.list objectAtIndex:selectedCity];
        return [model2.list count];
    }
    return 0;
}

// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(self.selectedType==SignUpViewControllerSelectedTypeSex || self.selectedType==SignUpViewControllerSelectedTypePetSex){
        return row==0?lang(@"man"):lang(@"woman");
    }
    
    else if(self.selectedType==SignUpViewControllerSelectedTypePetType){
        if(row==0)
            return lang(@"love_dog");
        else if(row==1)
            return lang(@"love_cat");
        else if(row==2)
            return  lang(@"love_other");
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeProvince){
        AreaModel* model=[areaArray objectAtIndex:row];
        return model.name;
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeCity){
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        AreaModel* model2=[model.list objectAtIndex:row];
        return model2.name;
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeArea){
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        AreaModel* model2=[model.list objectAtIndex:selectedCity];
        AreaModel* model3=[model2.list objectAtIndex:row];
        return model3.name;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if(self.selectedType==SignUpViewControllerSelectedTypeSex ){
        selectedSex=row;
        [sexField content:(row==0?lang(@"man"):lang(@"woman"))];
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypePetSex){
        selectedPetSex=row;
        [petSexField content:(row==0?lang(@"man"):lang(@"woman"))];
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypePetType){
        selectedPetType=row;
        if(row==2)
            [petTypeField content:lang(@"love_other")];
        else
            [petTypeField content:(row==0?lang(@"love_dog"):lang(@"love_cat"))];
    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeProvince){
        selectedProvince=row;
        selectedCity=-1;
        selectedArea=-1;
        AreaModel* model=[areaArray objectAtIndex:row];
        [provinceField content:model.name];
        [cityField content:nil];
        [areaField content:nil];

    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeCity){
        selectedCity=row;
        selectedArea=-1;
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        AreaModel* model2=[model.list objectAtIndex:row];
        [cityField content:model2.name];
        [areaField content:nil];

    }
    else if(self.selectedType==SignUpViewControllerSelectedTypeArea){
        selectedArea=row;
        AreaModel* model=[areaArray objectAtIndex:selectedProvince];
        AreaModel* model2=[model.list objectAtIndex:selectedCity];
        AreaModel* model3=[model2.list objectAtIndex:row];
        [areaField content:model3.name];

    }
    
}

#pragma mark actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==2)return;
    
    UIImagePickerController *imagepicker = [[[UIImagePickerController alloc] init] autorelease];
    imagepicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
    imagepicker.delegate = self;
    
    if(buttonIndex==1){
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagepicker.sourceType];
            imagepicker.mediaTypes = temp_MediaTypes;
            
        }
    }
    else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagepicker.sourceType];
            imagepicker.mediaTypes = temp_MediaTypes;
            imagepicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad) {
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        popover=nil;
        popover = [[UIPopoverController alloc] initWithContentViewController:imagepicker];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
            [imagepicker.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        popover.delegate=self;
        [popover presentPopoverFromRect:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //            [popover release];
    }
    else{
        [self presentModalViewController:imagepicker animated:YES];
    }

    
}

#pragma mark  imagepicker delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagepicker{
    
    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        imagepicker.delegate=nil;
        [imagepicker dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)imagepicker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    imagepicker.delegate=nil;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
        NSString *imageKey = @"UIImagePickerControllerOriginalImage";
        UIImage* image=nil;
        image=[info objectForKey:imageKey];
        if(image!=nil && imagepicker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil);
        }

        isSelectedImage=YES;
        [headerImageView setImage:image forState:UIControlStateNormal];
        
        [pool release];
        
    }

    if(popover!=nil){
        popover.delegate=nil;
        [popover dismissPopoverAnimated:NO];
        [popover release];
        popover=nil;
    }
    else{
        [imagepicker dismissModalViewControllerAnimated:YES];
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



#pragma alertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self backClick];
}


#pragma mark webview delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* url=[[request URL] absoluteString];
    
    const char* _url=[url UTF8String];
    if(_url!=nil && strstr(_url,"terms")!=nil){
        ServiceWebViewController* controller=[[ServiceWebViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        return NO;
    }
    else if(url!=nil && strstr(_url, "privacy")!=nil){
        ServiceWebViewController* controller=[[ServiceWebViewController alloc] init];
        controller.isPrivacy=YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        return NO;

    }

    return YES;
}

#pragma mark  touchscroller delegate

- (void)tableView:(UIScrollView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event{
    
    [self touchesBegan:touches withEvent:event];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nicknameField resignFirstResponder];
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    [personDescField resignFirstResponder];
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect=self.view.frame;
        rect.origin.y=0.0f;
        self.view.frame=rect;
    } completion:^(BOOL finish){
        
    }];
    
    
    [self hidePicker];

}

#pragma mark scrollview delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self touchesBegan:nil withEvent:nil];

}




@end
