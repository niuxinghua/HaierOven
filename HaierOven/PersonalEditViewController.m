//
//  PersonalEditViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/19.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "PersonalEditViewController.h"
#import "AddFoodAlertView.h"
@interface PersonalEditViewController ()<AddFoodAlertViewDelegate>{
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
    self.alertEdit.hidden = YES;
    self.alertEdit.delegate = self;
    [self.myWindow addSubview:self.alertEdit];
    
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

- (IBAction)editInfo:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
            self.alertEdit.alertTitleSting = @"修改昵称";
            self.alertEdit.label = self.nikeNameLabel;
            break;
        case 11:
            NSLog(@"修改性别");
            break;
        case 12:
            self.alertEdit.alertTitleSting = @"修改所在地";
            self.alertEdit.label = self.placeLabel;
            break;
        case 13:
            self.alertEdit.alertTitleSting = @"修改简介";
            self.alertEdit.label = self.descriptionLabel;
            break;
        case 14:
            NSLog(@"修改生日");
        case 15:
            self.alertEdit.alertTitleSting = @"修改邮箱";
            self.alertEdit.label = self.descriptionLabel;
            break;
        case 16:
            self.alertEdit.alertTitleSting = @"修改电话";
            self.alertEdit.label = self.phoneNumberLabel;
            break;
        default:
            break;
    }
    self.myWindow.hidden = NO;
    self.alertEdit.hidden = NO;
    CATransition *animation = [CATransition animation];
    //动画时间
    animation.duration = 0.5f;
    //先慢后快
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionReveal;
    [self.myWindow.layer addAnimation:animation forKey:@"animation"];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alertEdit.frame = alertShowRect;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)ChickAlert:(UILabel*)label andTextFailed:(UITextField*)textfield{
    self.alertEdit.hidden = YES;
    self.alertEdit.frame = alertHiddenRect;
    self.myWindow.hidden = YES;
    label.textColor = [UIColor darkGrayColor];

    textfield.text = @"";
    
    if (label.tag==1) {
        self.descrString = label.text;
        [self.tableView reloadData];
    }
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
@end
