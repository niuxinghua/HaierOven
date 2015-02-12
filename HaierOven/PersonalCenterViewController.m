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
#import "CookbookDetailControllerViewController.h"
#import "ActiveUserController.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"
#import "MyPointsController.h"

typedef NS_ENUM(NSUInteger, CurrentCookbookType) {
    CurrentCookbookTypePublished,
    CurrentCookbookTypePraised
};

@interface PersonalCenterViewController ()<MainViewNormalCellDelegate, PersonalCenterSectionViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UIImageView *personalAvater;

/**
 *  如果不是登录用户则隐藏
 */
@property (strong, nonatomic) IBOutlet UILabel *myDessertCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myPointsImageView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@property (strong, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *personDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIButton *watchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *genderImage;
@property (strong, nonatomic) User* currentUser;
@property (nonatomic) NSInteger publishedPageIndex;
@property (nonatomic) NSInteger praisedPageIndex;
@property (nonatomic) CurrentCookbookType cookbookType;
@property (strong, nonatomic) NSMutableArray* publishedCookbooks;
@property (strong, nonatomic) NSMutableArray* praisedCookbooks;
@property (strong, nonatomic) PersonalCenterSectionView* sectionHeader;
@end
#define HeaderViewRate         0.1388888
#define CellImageRate   0.8

@implementation PersonalCenterViewController

#pragma mark - 加载网络数据

- (void)loadUserInfo
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    NSString* userBaseId = self.currentUserId == nil ? CurrentUserBaseId : self.currentUserId;
    [[InternetManager sharedManager] getUserInfoWithUserBaseId:userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.currentUser = obj;
            [self updateUI];
            
        } else {
            [super showProgressErrorWithLabelText:@"获取个人信息失败" afterDelay:1];
        }
    }];
}

- (void)loadPublishedCookbooks
{
    NSString* userBaseId = self.currentUserId == nil ? CurrentUserBaseId : self.currentUserId;
    [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:userBaseId cookbookStatus:1 pageIndex:_publishedPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _publishedPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_publishedPageIndex == 1) {
                self.publishedCookbooks = obj;
            } else {
                [self.publishedCookbooks addObjectsFromArray:arr];
            }
            
            [self.table reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
        }
    }];
}

- (void)loadPraisedCookbooks
{
    NSString* userBaseId = self.currentUserId == nil ? CurrentUserBaseId : self.currentUserId;
    [[InternetManager sharedManager] getMyPraisedCookbooksWithUserBaseId:userBaseId pageIndex:_praisedPageIndex callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _praisedPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_praisedPageIndex == 1) {
                self.praisedCookbooks = obj;
            } else {
                [self.praisedCookbooks addObjectsFromArray:arr];
            }
            
            [self.table reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
        }
    }];
    
}

#pragma mark - 新消息标记及移除标记

- (void)updateMarkStatus:(NSNotification*)notification
{
    NSDictionary* countDict = notification.userInfo;
    NSInteger count = [countDict[@"count"] integerValue];
    if (count > 0) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
}

- (void)markNewMessage
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //小圆点
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-8, -5, 10, 10)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.height / 2;
    label.backgroundColor = [UIColor redColor];
    
    //添加到button
    [liebiaoBtn addSubview:label];
    self.navigationItem.leftBarButtonItem = liebiao;
    
}

- (void)deleteMarkLabel
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //移除小圆点Label
    for (UIView* view in liebiaoBtn.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //重新赋值leftBarButtonItem
    self.navigationItem.leftBarButtonItem = liebiao;
}

#pragma mark - 加载视图和初始化

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.publishedCookbooks = [NSMutableArray array];
        self.publishedPageIndex = 1;
        self.praisedCookbooks = [NSMutableArray array];
        self.praisedPageIndex = 1;
        self.cookbookType = CurrentCookbookTypePublished;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpSubviews];
    // Do any additional setup after loading the view.
    
    [self addHeader];
    [self addFooter];
    
    [self loadUserInfo];
    
    [self loadPublishedCookbooks];
    [self loadPraisedCookbooks];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:ModifiedUserInfoNotification object:nil];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton* leftButton = [[UIButton alloc] init];
        
        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [super setLeftBarButtonItemWithImageName:@"back.png" andTitle:nil andCustomView:leftButton];
        
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
        if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
            [self markNewMessage];
        } else {
            [self deleteMarkLabel];
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)updateUI
{
    if (![self.currentUserId isEqualToString:CurrentUserBaseId] && self.currentUserId != nil) {
        //不是登录用户隐藏积分、编辑按钮
        self.myDessertCountLabel.hidden = YES;
        self.myPointsImageView.hidden = YES;
        self.myPointsLabel.hidden = YES;
        self.editButton.hidden = YES;
    
    }
    
    [self.personalAvater setImageWithURL:[NSURL URLWithString:self.currentUser.userAvatar]];
    self.myDessertCountLabel.text = self.currentUser.points;
    self.personalNameLabel.text = self.currentUser.userName;
    self.personDescriptionLabel.text = self.currentUser.note;
    

    self.genderImage.image = [self.currentUser.sex isEqualToString:@"1"] ? IMAGENAMED(@"nan.png") : IMAGENAMED(@"femail.png");
    
    [self.watchBtn setTitle:[NSString stringWithFormat:@"%@关注", self.currentUser.focusCount] forState:UIControlStateNormal];
    [self.followBtn setTitle:[NSString stringWithFormat:@"粉丝%@", self.currentUser.followCount] forState:UIControlStateNormal];
    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
//    if (![self.currentUser.status isEqualToString:@"1"] && [userDefaults boolForKey:@"phoneLogin"]) {
//        
//        [[[UIAlertView alloc] initWithTitle:@"用户未激活" message:@"检测到您的账号还没激活，请激活账号吧" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"去激活", nil] show];
//        
//    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //下次再说
        
    } else { //去激活
        ActiveUserController* activeController = [self.storyboard instantiateViewControllerWithIdentifier:@"Active user controller"];
        activeController.activeMethod = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginId"];
        activeController.accType = AccTypeHaier;
        activeController.registerFlag = NO;
        activeController.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
        [self.navigationController pushViewController:activeController
                                             animated:YES];
        
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.table addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        if (vc.cookbookType == CurrentCookbookTypePublished) {
            vc.publishedPageIndex = 1;
            [vc loadPublishedCookbooks];
        } else {
            vc.praisedPageIndex = 1;
            [vc loadPraisedCookbooks];
        }
        
        
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.table headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.table addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
 
        
        if (vc.cookbookType == CurrentCookbookTypePublished) {
            vc.publishedPageIndex++;
            [vc loadPublishedCookbooks];
        } else {
            vc.praisedPageIndex++;
            [vc loadPraisedCookbooks];
        }
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.table footerEndRefreshing];
            
        });
        
    }];
    
}

-(void)setUpSubviews{
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [[UIView alloc] init];
    
    [self.table registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    
    self.personalAvater.layer.cornerRadius = self.personalAvater.frame.size.height/2;
    self.personalAvater.layer.masksToBounds = YES;
    self.personalAvater.userInteractionEnabled = YES;
    [self.personalAvater.layer setBorderWidth:1.5]; //边框宽度
    [self.personalAvater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    
    self.personalNameLabel.text = @"";
    self.personDescriptionLabel.text = @"";
    
    
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
    if (self.cookbookType == CurrentCookbookTypePublished) {
        cell.cookbook = self.publishedCookbooks[indexPath.row];
    } else {
        cell.cookbook = self.praisedCookbooks[indexPath.row];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cookbookType == CurrentCookbookTypePublished) {
        return self.publishedCookbooks.count;
    } else {
        return self.praisedCookbooks.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  PageW*CellImageRate;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.sectionHeader) {
        return self.sectionHeader;
    }
    
    PersonalCenterSectionView* headerView = [[PersonalCenterSectionView alloc] initWithFrame:CGRectMake(0, 0, PageW, PageW*HeaderViewRate) ];
    self.sectionHeader = headerView;
    headerView.delegate = self;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PageW*HeaderViewRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* cookbookDetailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    if (self.cookbookType == CurrentCookbookTypePublished) {
        Cookbook* cookbook = self.publishedCookbooks[indexPath.row];
        cookbookDetailController.cookbookId = cookbook.ID;
        cookbookDetailController.isAuthority = cookbook.isAuthority;
    } else {
        Cookbook* cookbook = self.praisedCookbooks[indexPath.row];
        cookbookDetailController.cookbookId = cookbook.ID;
        cookbookDetailController.isAuthority = cookbook.isAuthority;
    }
    [self.navigationController pushViewController:cookbookDetailController animated:YES];
}

#pragma mark-

#pragma mark topview各种点击事件

//跳转关注页面
- (IBAction)TurnWatchList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = YES;
    relation.userBaseId = self.currentUserId == nil ? CurrentUserBaseId : self.currentUserId;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"关注列表");
}

- (IBAction)TurnFollowsList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = NO;
    relation.userBaseId = self.currentUserId == nil ? CurrentUserBaseId : self.currentUserId;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"粉丝列表");
}

- (IBAction)Edit:(id)sender {
    PersonalEditViewController *personalEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalEditViewController"];
    personalEdit.user = self.currentUser;
    [self.navigationController pushViewController:personalEdit animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)myPointsTapped:(UITapGestureRecognizer *)sender
{
    MyPointsController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"My points controller"];
    controller.title = @"积分说明";
    controller.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
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

- (void)SectionType:(NSInteger)type
{
    if (type == 1) {
        self.cookbookType = CurrentCookbookTypePublished;
    } else {
        self.cookbookType = CurrentCookbookTypePraised;
    }
    [self.table reloadData];
}


- (IBAction)search:(id)sender {
    
    MainSearchViewController* search = [self.storyboard instantiateViewControllerWithIdentifier:@"Search view controller"];
    
    [self.navigationController pushViewController:search animated:YES];
    
}

- (IBAction)addCookbook:(id)sender {
    
    if (IsLogin) {
        UpLoadingMneuController* upload = [self.storyboard instantiateViewControllerWithIdentifier:@"UpLoadingMneuController"];
        [self.navigationController pushViewController:upload animated:YES];
    } else {
        [super openLoginController];
    }
    
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
