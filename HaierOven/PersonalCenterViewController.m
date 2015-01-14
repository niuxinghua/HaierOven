//
//  PersonalCenterViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterSectionView.h"
#import "MainViewNormalCell.h"
#import "PersonalEditViewController.h"
#import "RelationshipListViewController.h"

@interface PersonalCenterViewController ()<MainViewNormalCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIImageView *personalAvater;
@property (strong, nonatomic) IBOutlet UILabel *myDessertCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *personDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *watchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *genderImage;
@end
#define HeaderViewRate         0.1388888
#define CellImageRate   0.6

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpSubviews];
    // Do any additional setup after loading the view.
}

-(void)setUpSubviews{
    self.table.delegate = self;
    self.table.dataSource = self;
    
    
    [self.table registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    
    self.personalAvater.layer.cornerRadius = self.personalAvater.frame.size.height/2;
    self.personalAvater.layer.masksToBounds = YES;
    self.personalAvater.userInteractionEnabled = YES;
    [self.personalAvater.layer setBorderWidth:1.5]; //边框宽度
    [self.personalAvater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier =@"MainViewNormalCell";
    MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  PageW*CellImageRate;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    PersonalCenterSectionView* headerView = [[PersonalCenterSectionView alloc] initWithFrame:CGRectMake(0, 0, PageW, PageW*HeaderViewRate) ];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PageW*HeaderViewRate;
}

#pragma mark-

#pragma mark topview各种点击事件
//跳转关注页面
- (IBAction)TurnWatchList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = YES;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"关注列表");
}
- (IBAction)TurnFollowsList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = NO;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"粉丝列表");
}
- (IBAction)Edit:(id)sender {
    PersonalEditViewController *personalEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalEditViewController"];
    [self.navigationController pushViewController:personalEdit animated:YES];
}

#pragma mark-

-(void)ChickPlayBtn:(id)cellClass{
    
    NSLog(@"播播播放");
}
-(void)ChickLikeBtn:(id)cellClass andBtn:(UIButton *)btn{
    
    btn.selected = btn.selected==YES? NO:YES;
    if (btn.selected ==YES) {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.2)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [btn.layer addAnimation:k forKey:@"SHOW"];
    }
    
    NSLog(@"赞赞赞");
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
