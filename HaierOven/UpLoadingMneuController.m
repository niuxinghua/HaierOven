//
//  UpLoadingMneuController.m
//  HaierOven
//
//  Created by dongl on 14/12/28.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "UpLoadingMneuController.h"
#import "ChooseCoverView.h"
#import "CreatMneuController.h"
#import "PECropViewController.h"
typedef void (^result) (BOOL success);

@interface UpLoadingMneuController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChooseCoverViewDelegate,PECropViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UITextField *menuTitleTextFiled;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) ChooseCoverView  *chooseCoverView;

@property (strong, nonatomic) UIImage *tempImage;
@property BOOL isChooseCover;

@property (strong, nonatomic) NSMutableArray* tags;

@end

@implementation UpLoadingMneuController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [super showStatusTip:YES title:@"烤箱已连接！！"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubview];
    // Do any additional setup after loading the view.
}

-(void)setUpSubview{
    self.createBtn.layer.cornerRadius = 15;
    self.createBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSheetAction)];
    self.cover.userInteractionEnabled = YES;
    [self.cover addGestureRecognizer:tap];
    
    self.menuTitleTextFiled.delegate = self;
    self.descriptionTextView.delegate = self;
    
    
    //init chooseCoverView
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;

    self.chooseCoverView = [[ChooseCoverView alloc]initWithFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
    self.chooseCoverView.delegate = self;
    [self.myWindow addSubview:self.chooseCoverView];
    
    UITapGestureRecognizer *hiddenWindow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenW)];
    [self.myWindow addGestureRecognizer:hiddenWindow];
    
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)TakeCover:(NSInteger)tag{
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
    }completion:^(BOOL finished) {
        self.myWindow.hidden = YES;
        if (tag == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//                picker.allowsEditing = YES;  //是否可编辑
                picker.delegate = self;
                picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                //摄像头
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                
            }else{
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
                [alert show];
            }
        }else if (tag == 2) {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
//                pickerImage.allowsEditing = YES;
            }
            pickerImage.delegate = self;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
    }];
}

-(void)showSheetAction{
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{[self.chooseCoverView setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    textField.text = self.titleString;
   return [textField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    self.descriptionString = text;
    textView.textColor = [UIColor darkGrayColor];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length ==0) {
        textView.text =@"关于菜谱（选填）";
        textView.textColor = ([UIColor colorWithRed:170.0f/255 green:170.0f/255 blue:170.0f/255 alpha:0.6]);
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"关于菜谱（选填）"]) {
        textView.text = @"";
    }
    return YES;
}


- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.menuTitleTextFiled resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.tempImage = image;
    
    [self openEditor];
    
}


- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.tempImage;
    controller.toolbarHidden = YES;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 65.0f/52.0f;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navigationController animated:NO completion:NULL];
}



#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.cover.image = croppedImage;
    self.isChooseCover = YES;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}





- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建菜谱
- (IBAction)CreatMenu:(id)sender {
    
    if (!self.isChooseCover) {
        [super showProgressErrorWithLabelText:@"请选择菜谱封面" afterDelay:1];
        return;
    }
    
    if (self.menuTitleTextFiled.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请填写菜谱名称" afterDelay:1];
        return;
    }
    
    if (self.descriptionTextView.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请填写菜谱描述" afterDelay:1];
        return;
    }
    
    [self createCookbook];
    
}

#pragma mark -

#pragma mark - 获取标签



- (void)loadTagsCompletion:(result)callback
{
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] getTagsCallBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            
            self.tags = obj;
            
            callback(YES);
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"网络连接失败" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"获取标签失败" afterDelay:1];
            }
            callback(NO);
        }
    }];
}

- (void)createCookbook
{
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    
    CookbookDetail* cookbookDetail = [[CookbookDetail alloc] init];
    cookbookDetail.name = self.menuTitleTextFiled.text;
    cookbookDetail.desc = self.descriptionTextView.text;
    NSData* imageData = UIImageJPEGRepresentation(self.cover.image, 0.6);
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] uploadFile:imageData callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSDictionary* objDict = [obj firstObject];
            cookbookDetail.coverPhoto = objDict[@"name"];
            
            
            [self loadTagsCompletion:^(BOOL success) {
                if (success) {
                    CreatMneuController *creatMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatMneuController"];
                    creatMenu.cookbookCoverPhoto = self.cover.image;
                    creatMenu.cookbookDetail = cookbookDetail;
                    creatMenu.tags = self.tags;
                    [self.navigationController pushViewController:creatMenu animated:YES];
                    
                    UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
                    [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"创建菜谱页面"];
                }
            }];
            
            
            
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"网络连接失败" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"上传失败，请重试" afterDelay:1];
            }
        }
        
        
    }];
    
    
}



#pragma mark -

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int y = PageH - self.middleView.bottom;
    if (y<height) {
        self.view.frame = CGRectMake(0,y-height, PageW, PageH);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.view.frame = CGRectMake(0,64, PageW, PageH);
    
}

-(void)hiddenW{
    self.myWindow.hidden = YES;
    self.chooseCoverView.Frame=CGRectMake(0, PageH, PageW, PageW*0.58);
}
@end
