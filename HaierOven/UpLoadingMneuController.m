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
@interface UpLoadingMneuController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChooseCoverViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UITextField *menuTitleTextFiled;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *descriptionString;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) ChooseCoverView  *chooseCoverView;
@property BOOL isChooseCover;
@end

@implementation UpLoadingMneuController

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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
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
                picker.allowsEditing = YES;  //是否可编辑
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
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
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
    textField.text = self.titleString;
   return [textField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    self.descriptionString = text;
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
    self.cover.image = image;
    self.isChooseCover = YES;
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建菜谱
- (IBAction)CreatMenu:(id)sender {
    if (self.isChooseCover==NO||self.titleString.length == 0||self.descriptionString.length == 0) {
    }
    CreatMneuController *creatMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatMneuController"];
    [self.navigationController pushViewController:creatMenu animated:YES];
    
    
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
        self.view.frame = CGRectMake(0,-(height - y), PageW, PageH);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.view.frame = CGRectMake(0,64, PageW, PageH);
    
}

@end
