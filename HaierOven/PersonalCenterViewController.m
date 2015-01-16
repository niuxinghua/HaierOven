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

typedef NS_ENUM(NSUInteger, CurrentCookbookType) {
    CurrentCookbookTypePublished,
    CurrentCookbookTypePraised
};

@interface PersonalCenterViewController ()<MainViewNormalCellDelegate, PersonalCenterSectionViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIImageView *personalAvater;
@property (strong, nonatomic) IBOutlet UILabel *myDessertCountLabel;
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
#define CellImageRate   0.6

@implementation PersonalCenterViewController

#pragma mark - 加载网络数据

- (void)loadUserInfo
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    NSString* userBaseId = CurrentUserBaseId;
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
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:userBaseId cookbookStatus:1 pageIndex:_publishedPageIndex callBack:^(BOOL success, id obj, NSError *error) {
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
    NSString* userBaseId = CurrentUserBaseId;
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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUI
{
    [self.personalAvater setImageWithURL:[NSURL URLWithString:self.currentUser.userAvatar] placeholderImage:IMAGENAMED(@"QQQ.png")];
    self.myDessertCountLabel.text = self.currentUser.points;
    self.personalNameLabel.text = self.currentUser.nickName;
    self.personDescriptionLabel.text = self.currentUser.note;
    [self.watchBtn setTitle:[NSString stringWithFormat:@"%@关注", self.currentUser.followCount] forState:UIControlStateNormal];
    [self.followBtn setTitle:[NSString stringWithFormat:@"粉丝%@", self.currentUser.focusCount] forState:UIControlStateNormal];
    
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
    } else {
        Cookbook* cookbook = self.praisedCookbooks[indexPath.row];
        cookbookDetailController.cookbookId = cookbook.ID;
    }
    [self.navigationController pushViewController:cookbookDetailController animated:YES];
}

#pragma mark-

#pragma mark topview各种点击事件
//跳转关注页面
- (IBAction)TurnWatchList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = YES;
    relation.userBaseId = CurrentUserBaseId;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"关注列表");
}
- (IBAction)TurnFollowsList:(id)sender {
    RelationshipListViewController *relation = [self.storyboard instantiateViewControllerWithIdentifier:@"RelationshipListViewController"];
    relation.iswathching = NO;
    relation.userBaseId = CurrentUserBaseId;
    [self.navigationController pushViewController:relation animated:YES];
    NSLog(@"粉丝列表");
}
- (IBAction)Edit:(id)sender {
    PersonalEditViewController *personalEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalEditViewController"];
    personalEdit.user = self.currentUser;
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

- (void)SectionType:(NSInteger)type
{
    if (type == 1) {
        self.cookbookType = CurrentCookbookTypePublished;
    } else {
        self.cookbookType = CurrentCookbookTypePraised;
    }
    [self.table reloadData];
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
