//
//  PersonalEditViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/19.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "PersonalEditViewController.h"
#import "AddFoodAlertView.h"
#import "GenderAlertView.h"
#import "ChooseCoverView.h"
#import "PECropViewController.h"
#import "AlertDatePicker.h"
@interface PersonalEditViewController ()<AddFoodAlertViewDelegate,GenderAlertViewDelegate,ChooseCoverViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,AlertDatePickerDelegate>{
    CGRect alertShowRect;
    CGRect alertHiddenRect;
    CGSize size;
}
@property (strong, nonatomic) IBOutlet UIImageView *userAvater;
@property (strong, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *genderImage;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *avaterCell;
@property (strong, nonatomic) IBOutlet UIView *descriptionCell;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) AddFoodAlertView *alertEdit;
@property (strong, nonatomic) NSString *descrString;
@property (strong, nonatomic) GenderAlertView *alertGender;
@property (strong, nonatomic) ChooseCoverView *alertPhoto;
@property (strong, nonatomic) UIImage *tempAvatar;
@property (strong, nonatomic) AlertDatePicker *alertDate;
@end

@implementation PersonalEditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    
    alertShowRect = CGRectMake(PageW/2-(PageW-30)/2, PageH/3.2,PageW-30, 138);
    alertHiddenRect = CGRectMake(PageW/2, PageH/2, 0, 0);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpSubviews{
    self.userAvater = [UIImageView new];
    self.userAvater.frame = CGRectMake(22, (PageW/6-PageW/8)/2, PageW/8, PageW/8);
    self.userAvater.layer.cornerRadius = self.userAvater.height/2;
    self.userAvater.image = IMAGENAMED(@"QQQ.png");
    self.userAvater.layer.masksToBounds = YES;
    self.userAvater.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar)];
    [self.userAvater addGestureRecognizer:tap];
    [self.userAvater.layer setBorderWidth:1.5]; //边框宽度
    [self.userAvater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    [self.avaterCell addSubview:self.userAvater];
    

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.font = [UIFont fontWithName:GlobalTextFontName size:14.5];
    size = CGSizeZero;
    self.descrString = @"闲暇之时，写写美食专栏闲暇之时，写写美食专栏闲暇之时，写写美食专栏闲暇之时，写写美食专栏闲暇之时，写写美食专栏";
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.tag = 1;
    [self.descriptionCell addSubview:self.descriptionLabel];
    
    

    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.alertEdit = [[AddFoodAlertView alloc]initWithFrame:CGRectZero];
    self.alertEdit.center = self.myWindow.center;
    self.alertEdit.delegate = self;
    self.alertEdit.hidden = YES;
    [self.myWindow addSubview:self.alertEdit];
    
    self.alertGender = [[GenderAlertView alloc]initWithFrame:CGRectZero];
    self.alertGender.center = self.myWindow.center;
    self.alertGender.delegate = self;
    self.alertGender.hidden = YES;
    [self.myWindow addSubview:self.alertGender];
    
    
    self.alertPhoto = [[ChooseCoverView alloc]initWithFrame:CGRectZero];
    self.alertPhoto.delegate = self;
    [self.myWindow addSubview:self.alertPhoto];
    
    self.alertDate = [[AlertDatePicker alloc]initWithFrame:CGRectZero];
    self.alertDate.center = self.myWindow.center;
    self.alertDate.delegate = self;
    self.alertDate.hidden = YES;
    [self.myWindow addSubview:self.alertDate];
}
#pragma mark tableviewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
//{
//    return 10;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return PageW/6;
    }else if (indexPath.section ==1 &&indexPath.row==3) {
//        NSLog(@"height = %f",size.height+(PageW/8-size.height)*2);
        return size.height>PageW/8?size.height+16:PageW/8 ;
    }else return PageW/8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?0.5:1;
}
#pragma mark -

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -点击修改图标响应
- (IBAction)editInfo:(UIButton *)sender {
    
    self.myWindow.hidden = NO;
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //先慢后快
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionReveal;
    [self.myWindow.layer addAnimation:animation forKey:@"animation"];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        switch (sender.tag) {
            case 10:
                self.alertEdit.alertTitleSting = @"修改昵称";
                self.alertEdit.label = self.nikeNameLabel;
                self.alertEdit.frame = alertShowRect;
                self.alertEdit.hidden = NO;
                break;
            case 11:
                self.alertGender.frame = CGRectMake(alertShowRect.origin.x, alertShowRect.origin.y, alertShowRect.size.width, 81);
                self.alertGender.hidden = NO;
                break;
            case 12:
                self.alertEdit.alertTitleSting = @"修改所在地";
                self.alertEdit.label = self.placeLabel;
                self.alertEdit.frame = alertShowRect;
                self.alertEdit.hidden = NO;
                
                break;
            case 13:
                self.alertEdit.alertTitleSting = @"修改简介";
                self.alertEdit.label = self.descriptionLabel;
                self.alertEdit.frame = alertShowRect;
                self.alertEdit.hidden = NO;

                break;
            case 14:
                self.alertDate.frame = CGRectMake(alertShowRect.origin.x,alertShowRect.origin.y, alertShowRect.size.width, 242);
                self.alertDate.birthLabel = self.birthdayLabel;
                self.alertDate.hidden = NO;
                break;
            
            case 15:
                self.alertEdit.alertTitleSting = @"修改邮箱";
                self.alertEdit.label = self.emailLabel;
                self.alertEdit.frame = alertShowRect;
                self.alertEdit.hidden = NO;

                break;
            case 16:
                self.alertEdit.alertTitleSting = @"修改电话";
                self.alertEdit.label = self.phoneNumberLabel;
                self.alertEdit.frame = alertShowRect;
                self.alertEdit.hidden = NO;

                break;
            default:
                break;
        }

        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - alertEditDelegate
-(void)ChickAlert:(UILabel*)label andTextFailed:(UITextField*)textfield{
    if (label.tag==2){
        if ([MyTool validateEmail:label.text]) {
            label.text = textfield.text;
        }else
            [super showProgressErrorWithLabelText:@"请输入正确邮箱" afterDelay:1.0];
    }
    else if (label.tag ==3){
        if ([MyTool validateTelephone:label.text]) {
            label.text = textfield.text;
        }else
            [super showProgressErrorWithLabelText:@"请输入正确手机号" afterDelay:1.0];
        
    }else if (label.tag==1) {
        self.descrString = textfield.text;
        [self.tableView reloadData];
    }

    self.alertEdit.hidden = YES;
    self.alertEdit.frame = alertHiddenRect;
    self.myWindow.hidden = YES;
    textfield.text = @"";
    
    [textfield resignFirstResponder];
}
-(void)Cancel{
    self.alertEdit.hidden = YES;
    self.alertEdit.frame = alertHiddenRect;
    self.myWindow.hidden = YES;
}


-(void)setDescrString:(NSString *)descrString{
    _descrString = descrString;
    size = [MyUtils getTextSizeWithText:descrString  andTextAttribute:@{NSFontAttributeName :self.descriptionLabel.font} andTextWidth:PageW-160];
    self.descriptionLabel.text = descrString;
    float y = size.height>PageW/8?8:(PageW/8-size.height)/2;
    self.descriptionLabel.frame = CGRectMake(102, y, size.width,size.height);

}



#pragma  mark - alertGenderDelegate
-(void)chooseGender:(NSInteger)gender{
    self.genderLabel.text = gender==1?@"男":@"女";
    self.genderImage.image = gender==1?IMAGENAMED(@"nan"):IMAGENAMED(@"femail");
    self.alertGender.hidden = YES;
    self.myWindow.hidden = YES;
    self.alertGender.frame =alertHiddenRect;
}




#pragma mark- alertPhotoDelegate

-(void)changeAvatar{
    self.myWindow.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{[self.alertPhoto setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];

}
-(void)TakeCover:(NSInteger)tag{
    [UIView animateWithDuration:0.3 animations:^{[self.alertPhoto setFrame:CGRectMake(0, PageH, PageW, PageW*0.58)];
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
    [UIView animateWithDuration:0.3 animations:^{[self.alertPhoto setFrame:CGRectMake(0, PageH-PageW*0.58, PageW, PageW*0.58)];
    }completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.tempAvatar = image;
    
    [self openEditor];
    
}
- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.tempAvatar;
    controller.toolbarHidden = YES;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 1.0f;
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
    self.userAvater.image = croppedImage;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - alertDateDelegate
-(void)ChangeUserBrith:(NSString *)birthday{
    self.birthdayLabel.text = birthday;
    self.alertDate.hidden = YES;
    self.myWindow.hidden = YES;
    self.alertDate.frame =alertHiddenRect;
}
-(void)UnEdit{
    self.alertDate.hidden = YES;
    self.myWindow.hidden = YES;
    self.alertDate.frame =alertHiddenRect;
}
@end
