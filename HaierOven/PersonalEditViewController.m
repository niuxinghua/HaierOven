//
//  PersonalEditViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/19.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "PersonalEditViewController.h"
@interface PersonalEditViewController ()
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
@property CGSize size;
@end

@implementation PersonalEditViewController
@synthesize size;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
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
    NSString *string = @"闲暇之时，写写美食专栏";
    size = [MyUtils getTextSizeWithText:string  andTextAttribute:@{NSFontAttributeName :self.descriptionLabel.font} andTextWidth:PageW-160];
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.text = string;
    self.descriptionLabel.numberOfLines = 0;
    float y = size.height>PageW/8?8:(PageW/8-size.height)/2;
    self.descriptionLabel.frame = CGRectMake(102, y, size.width,size.height);
    [self.descriptionCell addSubview:self.descriptionLabel];
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
@end
