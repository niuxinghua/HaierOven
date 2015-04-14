//
//  SuggestPostViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SuggestPostViewController.h"

@interface SuggestPostViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    CGFloat tempFloat;
}
@property (strong, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (strong, nonatomic) IBOutlet UILabel *descrCountLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation SuggestPostViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}
-(void)setUpSubviews{
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 15;
    
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.cornerRadius = 3;
    self.descriptionTextView.layer.borderWidth = 1.0f;
    self.descriptionTextView.layer.borderColor = GlobalOrangeColor.CGColor;
    self.descriptionTextView.delegate = self;
    
    self.phoneTextField.layer.masksToBounds = YES;
    self.phoneTextField.layer.cornerRadius = 3;
    self.phoneTextField.layer.borderWidth = 1.0f;
    self.phoneTextField.layer.borderColor = GlobalOrangeColor.CGColor;
    self.phoneTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)PostSuggest:(id)sender {
    
    if (self.descriptionTextView.text.length == 0) {
        [super showProgressErrorWithLabelText:@"请填写您的意见" afterDelay:1];
        return;
    }
    
    if (![MyTool validateTelephone:self.phoneTextField.text]) {
        [super showProgressErrorWithLabelText:@"请输入正确手机号" afterDelay:1];
        return;
    }
    
    NSLog(@"提交建议");

    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] feedbackWithContent:self.descriptionTextView.text phone:self.phoneTextField.text callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            [MobClick event:@"suggest_feedback"];
            [super showProgressCompleteWithLabelText:@"谢谢反馈" afterDelay:1];
            [self performSelector:@selector(close) withObject:nil afterDelay:1.5];
        } else {
            [super showProgressCompleteWithLabelText:@"反馈失败" afterDelay:1];
        }
        
        
    }];
    
}

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int k = PageH - tempFloat;
    if (k<height) {
        self.view.frame = CGRectMake(0,-(height - k), PageW, PageH);
    }else{
        self.view.frame = CGRectMake(0,64, PageW, PageH);
    }
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    self.view.frame = CGRectMake(0,64, PageW, PageH);
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    tempFloat = textField.bottom+64;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    tempFloat = textView.origin.y + [MyUtils getTextSizeWithText:textView.text andTextAttribute:@{NSFontAttributeName:textView.font} andTextWidth:Main_Screen_Width - 32].height;
    self.placeholderLabel.hidden = !(textView.text.length == 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    textField.text = self.titleString;
    return [textField resignFirstResponder];
}


//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    tempFloat = textView.origin.y+64;
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
//    self.placeholderLabel.hidden = text.length>0?YES:NO;
    self.descrCountLabel.text = [NSString stringWithFormat:@"%d/500",textView.text.length];
    return YES;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.descriptionTextView resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
