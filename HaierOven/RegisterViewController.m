//
//  RegisterViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (strong, nonatomic) UIImageView *orangeLine;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *PhoneBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetUpSubView{
    self.registerType = RegisterTypeEmail;
    
    self.orangeLine = [UIImageView new];
    self.orangeLine.image = [MyTool createImageWithColor:GlobalOrangeColor];
    self.orangeLine.frame = CGRectMake(self.emailBtn.left+20, self.emailBtn.bottom-7, self.emailBtn.width-40, 2);
    [self.view addSubview:self.orangeLine];

}

-(void)setRegisterType:(RegisterType)registerType{
    _registerType = registerType;
    if (registerType == RegisterTypeEmail) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.orangeLine.frame = CGRectMake(self.emailBtn.left+20, self.emailBtn.bottom-7, self.emailBtn.width-40, 2);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.orangeLine.frame = CGRectMake(self.PhoneBtn.left+20, self.PhoneBtn.bottom-7, self.PhoneBtn.width-40, 2);
        }];
    }
}

- (IBAction)RegisterType:(UIButton*)sender {
    self.registerType = sender.tag;
}
- (IBAction)Turnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
