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
#import "RDRStickyKeyboardView.h"


@interface CookbookDetailControllerViewController () <UIScrollViewDelegate, AutoSizeLabelViewDelegate, CookbookSectionHeaderDelegate>
{
    CGFloat _lastContentOffsetY;
    NSInteger _commentPageIndex;
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

@property (weak, nonatomic) IBOutlet UILabel *cookbookNameLabel;


@property (weak, nonatomic) IBOutlet AutoSizeLabelView *tagsView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDescCell;

@property (weak, nonatomic) IBOutlet UILabel *cookbookDescLabel;


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

@property (strong, nonatomic) NSMutableArray* comments;

@property (nonatomic) CurrentContentType contentType;

@property (nonatomic, strong) RDRStickyKeyboardView *contentWrapper;

@property (strong, nonatomic) UIWindow* myWindow;

@end

@implementation CookbookDetailControllerViewController

#pragma mark - 获取菜谱详情

- (void)loadCookbookDetail
{
    [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
    [[InternetManager sharedManager] getCookbookDetailWithCookbookId:self.cookbook.ID userBaseId:@"5" callBack:^(BOOL success, id obj, NSError *error) {
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

- (void)loadComments
{
//    [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
    [[InternetManager sharedManager] getCommentsWithCookbookId:self.cookbook.ID andPageIndex:_commentPageIndex callBack:^(BOOL success, id obj, NSError *error) {
//        [super hiddenProgressHUD];
        if (success) {
            self.comments = obj;
            if (self.commentsTableView == nil) {
                [self initTableViewWithContentType:CurrentContentTypeComment];
                [self setupWrapper];
            }
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
    
    self.cookbookNameLabel.text = self.cookbook.name;
    
    self.cookbookDescLabel.text = self.cookbookDetail.desc;
    
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
            tableView.scrollEnabled = YES;
            
            tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            self.commentsTableView = tableView;
            
            tableView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64 - 50);
            
            tableView.tag = 7;
            
            // 这里应该从网络获取Comments
            
            if (self.comments.count == 0) {
                Comment* comment = [[Comment alloc] init];
                comment.content = @"这个菜谱真好啊！";
                comment.creatorAvatar = @"http://d.hiphotos.baidu.com/image/pic/item/09fa513d269759ee2ea448afb1fb43166c22dfd9.jpg";
                comment.modifiedTime = @"2014-12-31 10:47";
                comment.creatorLoginName = @"黄靖雯";
                [self.comments addObject:comment];
                [self.comments addObject:comment];
                [self.comments addObject:comment];
                [self.comments addObject:comment];
            
            }
            
            CommentViewController* controller = [[CommentViewController alloc] initWithData:self.comments andController:self];
            self.commentsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"CommentCountCell" bundle:nil] forCellReuseIdentifier:@"Comment count cell"];
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
        _commentPageIndex = 1;
        self.comments = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self loadCookbookDetail];
    [self loadComments];
    
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

- (void)setupWrapper
{
    // Setup wrapper
    if (self.contentWrapper == nil) {
        self.contentWrapper = [[RDRStickyKeyboardView alloc] initWithScrollView:self.commentsTableView];
        self.contentWrapper.frame = self.cookbookDetailCell.contentView.bounds;
        self.contentWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.contentWrapper.placeholder = @"Message";
        [self.contentWrapper.inputView.rightButton addTarget:self action:@selector(didTapSend:) forControlEvents:UIControlEventTouchUpInside];
//        [self.cookbookDetailCell.contentView addSubview:self.contentWrapper];
//        self.myWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 200, Main_Screen_Width, 60)];
////        self.myWindow.frame = self.tableView.bounds;
//        self.myWindow.backgroundColor =[UIColor orangeColor];
//        self.myWindow.windowLevel = UIWindowLevelAlert;
//        [self.myWindow makeKeyAndVisible];
//        self.myWindow.userInteractionEnabled = YES;
//        
//        [self.myWindow addSubview:self.contentWrapper];
       
    }
    
}

- (void)didTapSend:(id)sender
{
    [self.contentWrapper hideKeyboard];
    
    NSLog(@"添加评论");
    
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
            if (self.contentType == CurrentContentTypeComment) {
                self.commentsTableView.scrollEnabled = YES;
            }
            
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
                return minHeight;
                break;
            }
            default:
                return minHeight;
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
    
    self.contentType = type;
    
    for (UIView* view in self.cookbookDetailCell.contentView.subviews) {
        if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[RDRStickyKeyboardView class]]) {
            [view removeFromSuperview];
        }
    }
    switch (type) {
        case CurrentContentTypeFoods:
        {

            [self.cookbookDetailCell.contentView addSubview:self.foodsTableView];
            
            break;
        }
            
        
        case CurrentContentTypeMethods:
        {
            
            [self.cookbookDetailCell.contentView addSubview:self.stepsTableView];
            break;
        }
            
        case CurrentContentTypeComment:
        {

//            [self.cookbookDetailCell.contentView addSubview:self.commentsTableView];
            [self.cookbookDetailCell.contentView addSubview:self.contentWrapper];
            break;
        }
            
            
        default:
            break;
    }
    [self.tableView reloadData];

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
