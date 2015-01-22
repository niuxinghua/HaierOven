//
//  ActiveUserController.m
//  HaierOven
//
//  Created by 刘康 on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "ActiveUserController.h"

@interface ActiveUserController ()


@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVefifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation ActiveUserController



//重新获得验证码：
//http://103.8.220.166:40000/commonapp/uvcs
//
//{
//    "loginName":"13611609561",
//    "validateType":1,
//    "validateScene":1,
//    "sendTo":"13611609561",
//    "accType":0
//}

//第三方补充信息：
//url:app/user/addthird
//参数格式：
//{"userBaseID":25,"passWord":"","email":"cjsyclt@163.com","mobile":"13621640580","userProfile":{"nickName":"cjsyclt","userName":"litao"}}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
