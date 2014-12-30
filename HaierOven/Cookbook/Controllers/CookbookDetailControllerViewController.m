//
//  CookbookDetailControllerViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookDetailControllerViewController.h"
#import "CookbookSectionHeaderView.h"
#import "AutoSizeLabelView.h"
#import "CookbookDetail.h"
#import "FoodsViewController.h"
#import "StepsViewController.h"
#import "CommentViewController.h"

@interface CookbookDetailControllerViewController () <UIScrollViewDelegate, AutoSizeLabelViewDelegate, CookbookSectionHeaderDelegate>
{
    CGFloat _lastContentOffsetY;
}

#pragma mark - NavigationBar

@property (weak, nonatomic) IBOutlet UIView *rightNavigationView;


#pragma mark - headerView
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *cookbookImageView;

@property (weak, nonatomic) IBOutlet UIImageView *creatorAvatar;

@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

#pragma mark - section 0

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookTitleCell;

@property (weak, nonatomic) IBOutlet AutoSizeLabelView *tagsView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDescCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *learnCookBtnCell;

#pragma mark - section 1

@property (strong, nonatomic) CookbookSectionHeaderView* sectionHeaderView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDetailCell;

@property (strong, nonatomic) UITableView* foodsTableView;

@property (strong, nonatomic) id foodsTableViewDataSource;

@property (strong, nonatomic) UITableView* stepsTableView;

@property (strong, nonatomic) id stepsTableViewDataSource;

@property (strong, nonatomic) UITableView* commentsTableView;

@property (strong, nonatomic) id commentsTableViewDataSource;

#pragma mark - Others

@property (strong, nonatomic) CookbookDetail* cookbookDetail;

@property (nonatomic) CurrentContentType contentType;

@end

@implementation CookbookDetailControllerViewController

#pragma mark - 获取菜谱详情

- (void)loadCookbookDetail
{
    [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
    [[InternetManager sharedManager] getCookbookDetailWithCookbookId:self.cookbook.ID callBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            self.cookbookDetail = obj;
            [self updateUI];
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
            }
        }
        
    }];
}

- (void)updateUI
{
    // 设置第二个分区默认显示内容
    if (self.foodsTableView == nil) {
        [self initTableViewWithContentType:CurrentContentTypeFoods];
    }
    
    if (self.stepsTableView == nil) {
        [self initTableViewWithContentType:CurrentContentTypeMethods];
    }
    
    // 其他显示的内容
    NSMutableArray* tagNames = [NSMutableArray array];
    for (Tag* tag in self.cookbookDetail.tags) {
        [tagNames addObject:tag.name];
    }
    self.tagsView.tags = [tagNames copy];
    
    // reloadData
    [self.tableView reloadData];
}

- (void)initTableViewWithContentType:(CurrentContentType)type
{
    UITableView* tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    tableView.backgroundColor = GlobalTableViewColor;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.scrollEnabled = NO;
    switch (type) {
        case CurrentContentTypeFoods:
        {
            self.foodsTableView = tableView;
            tableView.frame = CGRectMake(0, 0, Main_Screen_Width, MAX(Main_Screen_Height - 64 - 50, 50 + self.cookbookDetail.foods.count * 44));
            tableView.tag = 5;
            FoodsViewController* controller = [[FoodsViewController alloc] initWithFoods:self.cookbookDetail.foods];
            self.foodsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"AddShoppingListCell" bundle:nil] forCellReuseIdentifier:@"Add shopping list cell"];
            [tableView registerNib:[UINib nibWithNibName:@"FoodCell" bundle:nil] forCellReuseIdentifier:@"Food cell"];
            [self.cookbookDetailCell.contentView addSubview:self.foodsTableView];
            break;
        }
        case CurrentContentTypeMethods: //放在屏幕外面
        {
            self.stepsTableView = tableView;
            tableView.frame = CGRectMake(0, 0, Main_Screen_Width, 44 * 2 + 225 * self.cookbookDetail.steps.count);
            tableView.tag = 6;
            StepsViewController* controller = [[StepsViewController alloc] initWithCookbookDetail:self.cookbookDetail];
            self.stepsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"StepCell" bundle:nil] forCellReuseIdentifier:@"Step cell"];
            [tableView registerNib:[UINib nibWithNibName:@"OvenInfoCell" bundle:nil] forCellReuseIdentifier:@"Oven info cell"];
            [tableView registerNib:[UINib nibWithNibName:@"MethodCell" bundle:nil] forCellReuseIdentifier:@"Method cell"];
//            [self.cookbookDetailCell.contentView addSubview:self.stepsTableView];
            break;

        }
        case CurrentContentTypeComment:
        {
            
            self.commentsTableView = tableView;
            
            tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 50);
            
            tableView.tag = 7;
            
            // 这里应该从网络获取Comments
            CommentViewController* controller = [[CommentViewController alloc] initWithData:[NSMutableArray array] andController:self];
            self.commentsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            
            [tableView registerNib:[UINib nibWithNibName:@"CommentListCell" bundle:nil] forCellReuseIdentifier:@"Comment list cell"];
            
            break;
            
        }
        default:
            break;
    }
}

#pragma mark - 加载系列

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.sectionHeaderView = [[CookbookSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50) andCurrentContentType:CurrentContentTypeFoods];
        self.sectionHeaderView.delegate = self;
        self.contentType = CurrentContentTypeFoods;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadCookbookDetail];
}

- (void)setupSubviews
{
    // 设置NavigationBar
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAMED(@"clear.png") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:IMAGENAMED(@"clear.png")];
    self.navigationController.navigationBar.translucent = YES;
    
    // 设置其他
    self.creatorAvatar.layer.masksToBounds = YES;
    self.creatorAvatar.layer.cornerRadius = self.creatorAvatar.height / 2.0;
    
    self.tagsView.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.rightNavigationView.alpha = 0.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _lastContentOffsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.tag != 5) { // 不是滑动评论
        if (scrollView.contentOffset.y > self.cookbookImageView.height - 64) {
            [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
            [self showRightNavigationView:YES];
            
        } else if (scrollView.contentOffset.y > self.cookbookImageView.height) {
            
        } else {
            [self.navigationController.navigationBar setBackgroundImage:IMAGENAMED(@"clear.png") forBarMetrics:UIBarMetricsDefault];
            [self showRightNavigationView:NO];
            
        }
        
        if (scrollView.contentOffset.y < _lastContentOffsetY)
        {
            //        NSLog(@"向下拉动");
            if (scrollView.contentOffset.y < 0) {
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self showRightNavigationView:NO];
            }
            
        } else if (scrollView.contentOffset.y > _lastContentOffsetY)
        {
            
            //        NSLog(@"向上拉动");
            
            
        }
    } else {    //滑动评论
        NSLog(@"%f", scrollView.contentOffset.y);
    }
    
    
}

- (void)showRightNavigationView:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rightNavigationView.alpha = show ? 1.0 : 0.0;
    }];
    self.rightNavigationView.userInteractionEnabled = show;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.cookbookTitleCell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return self.cookbookDescCell;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        return self.learnCookBtnCell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return self.cookbookDetailCell;
    }
    
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
        return view;
    }
    
    // 如果sectionHeader不是属性的话，每次滑动都会init新的对象
    CookbookSectionHeaderView* headerView = self.sectionHeaderView;

    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 92;
                break;
            case 1:
                return 70;
                break;
            case 2:
                return 45;
                break;
            default:
                break;
        }
    } else {
        CGFloat minHeight = Main_Screen_Height - 64 - 50; //屏幕高度 - NavigationBar高度 - 状态栏高度 - SectionHeaderView高度
        switch (self.contentType) {
            case CurrentContentTypeFoods:
            {
                return MAX(minHeight, 50 + self.cookbookDetail.foods.count * 44);
                break;
            }
            case CurrentContentTypeMethods:
            {
                return MAX(minHeight, [self getStepsViewHeight]);
                break;
            }
            case CurrentContentTypeComment:
            {
                
                break;
            }
            default:
                return Main_Screen_Height - 64 - 50; //屏幕高度 - NavigationBar高度 - 状态栏高度 - SectionHeaderView高度
                break;
        }
        
        
    }
    
    return 0;
    
}

- (CGFloat)getStepsViewHeight
{
    CGFloat height = 0.0f;
    height += 88; //两个固定cell高度
    for (Step* step in self.cookbookDetail.steps) {
        height += 20; // 图片距离上边距
        height += (Main_Screen_Width - 54 - 26) * 7 / 12;   //图片宽高比位7:12
        height += 8; // 图片和Label的间距
        height += [MyUtils getTextSizeWithText:step.desc andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTitleFontName size:12.0f]} andTextWidth:Main_Screen_Width - 54 - 26].height; // 文字高度
        height += 8; //Label距离下边距
    }
    
    return height;
}

#pragma mark - CookbookSectionHeaderDelegate

- (void)CookbookSectionView:(CookbookSectionHeaderView *)sectionHeader didTappedWithContentType:(CurrentContentType)type
{
//    CGRect frameOfFoods;
//    CGRect frameOfSteps;
//    CGRect frameOfComment;
    for (UIView* view in self.cookbookDetailCell.contentView.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
        }
    }
    switch (type) {
        case CurrentContentTypeFoods:
        {
//            frameOfFoods = self.foodsTableView.frame;
//            frameOfFoods.origin.x = 0;
//            frameOfSteps = self.stepsTableView.frame;
//            frameOfSteps.origin.x = Main_Screen_Width;
//            frameOfComment = self.commentsTableView.frame;
//            frameOfComment.origin.x = Main_Screen_Width * 2;
            [self.cookbookDetailCell.contentView addSubview:self.foodsTableView];
            
            break;
        }
            
        
        case CurrentContentTypeMethods:
        {
//            CGRect frameOfFoods = self.foodsTableView.frame;
//            frameOfFoods.origin.x = - Main_Screen_Width;
//            CGRect frameOfSteps = self.stepsTableView.frame;
//            frameOfSteps.origin.x = 0;
//            CGRect frameOfComment = self.commentsTableView.frame;
//            frameOfComment.origin.x = Main_Screen_Width;
            
            [self.cookbookDetailCell.contentView addSubview:self.stepsTableView];
            break;
        }
            
        case CurrentContentTypeComment:
        {
//            CGRect frameOfFoods = self.foodsTableView.frame;
//            frameOfFoods.origin.x = - Main_Screen_Width * 2;
//            CGRect frameOfSteps = self.stepsTableView.frame;
//            frameOfSteps.origin.x = - Main_Screen_Width;
//            CGRect frameOfComment = self.commentsTableView.frame;
//            frameOfComment.origin.x = 0;
            [self.cookbookDetailCell.contentView addSubview:self.commentsTableView];
            break;
        }
            
            
        default:
            break;
    }
    [self.tableView reloadData];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.foodsTableView.frame = frameOfFoods;
//        self.stepsTableView.frame = frameOfSteps;
//        self.commentsTableView.frame = frameOfComment;
//    }];
}

#pragma mark - AutoSizeLabelViewDelegate

- (void)chooseTags:(UIButton *)btn
{
    NSLog(@"Button title: %@", btn.currentTitle);
}

#pragma mark - 按钮响应事件

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
