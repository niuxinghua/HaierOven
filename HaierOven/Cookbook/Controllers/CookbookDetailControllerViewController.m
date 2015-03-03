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
#import "DAKeyboardControl.h"
#import "AddShoppingListCell.h"
#import "StudyCookViewController.h"
#import "DeviceViewController.h"
#import "PersonalCenterViewController.h"
#import "DeviceBoardViewController.h"

@interface CookbookDetailControllerViewController () <UIScrollViewDelegate, AutoSizeLabelViewDelegate, CookbookSectionHeaderDelegate, AddShoppingListCellDelegate, UMSocialDataDelegate, UMSocialUIDelegate, SkillCellDelegate>
{
    CGFloat _lastContentOffsetY;
    BOOL _iOS7OvenListFlag;     //避免iOS7系统从烤箱列表跳回来时sectionHeader不在顶部
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
/**
 *  是否是官方菜谱
 */
@property (weak, nonatomic) IBOutlet UIButton *authorityButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookTitleCell;

@property (weak, nonatomic) IBOutlet UILabel *cookbookNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;


@property (weak, nonatomic) IBOutlet AutoSizeLabelView *tagsView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDescCell;

@property (weak, nonatomic) IBOutlet UILabel *cookbookDescLabel;


@property (weak, nonatomic) IBOutlet UITableViewCell *learnCookBtnCell;


@property (weak, nonatomic) IBOutlet UIButton *learnButton;

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

@property (nonatomic) NSInteger commentPageIndex;

@property (strong, nonatomic) NSMutableArray* comments;

@property (nonatomic) CurrentContentType contentType;

@property (strong, nonatomic) UIWindow* window;

@property (weak, nonatomic) UITextField * commentTextField;

@property (nonatomic)NSInteger shoppingListCount;

@property (strong, nonatomic) NSDate* lastCommentTime;

@end

@implementation CookbookDetailControllerViewController

#pragma mark - 获取菜谱详情

- (void)loadCookbookDetail
{
    if (self.isPreview) {
        [self updateUI];
    } else {
        
        //统计页面加载耗时
        UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
        
        self.cookbookDescLabel.text = @"";
        [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
        [[InternetManager sharedManager] getCookbookDetailWithCookbookId:self.cookbookId userBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
            [super hiddenProgressHUD];
            if (success) {
                self.cookbookDetail = obj;
                [self updateUI];
                
                UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
                [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"菜谱详情页面"];
                
            } else {
                if (error.code == InternetErrorCodeConnectInternetFailed) {
                    [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
                } else {
                    [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
                }
            }
            
        }];
    }
    
}

- (void)loadComments
{
//    [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
    [[InternetManager sharedManager] getCommentsWithCookbookId:self.cookbookId andPageIndex:_commentPageIndex callBack:^(BOOL success, id obj, NSError *error) {
//        [super hiddenProgressHUD];
        if (success) {
          
            NSArray* arr = obj;
            if (arr.count < PageLimit && _commentPageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_commentPageIndex == 1) {
                self.comments = obj;
            } else {
                [self.comments addObjectsFromArray:arr];
            }
            [self.commentsTableView reloadData];
            
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
            }
        }
        if (self.commentsTableView == nil) {
            [self initTableViewWithContentType:CurrentContentTypeComment];
        }
        
//        [self setupWrapper];
    }];
}

- (void)getFollowedList
{
    
    NSString* userBaseId = CurrentUserBaseId;
    [[InternetManager sharedManager] getFollowersWithUserBaseId:userBaseId andPageIndex:1 callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            
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
 
    NSString* coverPath = self.isPreview ? [BaseOvenUrl stringByAppendingPathComponent:self.cookbookDetail.coverPhoto] : self.cookbookDetail.coverPhoto;

    [self.cookbookImageView setImageWithURL:[NSURL URLWithString:coverPath]];
    
    if (self.isPreview) {
        [self.creatorAvatar setImageWithURL:[NSURL URLWithString:[DataCenter sharedInstance].currentUser.userAvatar]];
        self.creatorNameLabel.text = [DataCenter sharedInstance].currentUser.userName;
    } else {
        [self.creatorAvatar setImageWithURL:[NSURL URLWithString:self.cookbookDetail.creator.avatarPath]];
        self.creatorNameLabel.text = self.cookbookDetail.creator.userName;
    }
    
    // 其他显示的内容
    NSMutableArray* tagNames = [NSMutableArray array];
    for (Tag* tag in self.cookbookDetail.tags) {
        [tagNames addObject:tag.name];
    }
    self.tagsView.style = AutoSizeLabelViewStyleMenuDetail;
    self.tagsView.tags = [tagNames copy];
    
    
    
    self.cookbookNameLabel.text = self.cookbookDetail.name;
    
    self.cookbookDescLabel.text = self.cookbookDetail.desc;
    
    // reloadData
    [self.tableView reloadData];
    
    
    // 是否是官方菜谱
    self.authorityButton.hidden = !self.isAuthority;
    
//    if (self.cookbookDetail.creator.userLevel != nil) {
//        
//        if ([self.cookbookDetail.creator.userLevel isEqualToString:@"1"] || [self.cookbookDetail.creator.userLevel isEqualToString:@"2"]) {
//            self.authorityButton.hidden = NO;
//        } else {
//            self.authorityButton.hidden = YES;
//        }
//        
//        
//    } else {
////        //假数据
////        if ([cookbook.creator.userName isEqualToString:@"官方厨神"]) {
////            self.cookStarImageView.hidden = NO;
////            self.AuthorityLabel.hidden = NO;
////        } else {
////            self.cookStarImageView.hidden = YES;
////            self.AuthorityLabel.hidden = YES;
////        }
//        
//    }

    
    // 如果是自己发布的菜谱不显示关注按钮
    if ([self.cookbookDetail.creator.userBaseId isEqualToString:CurrentUserBaseId] || self.isPreview) {
        self.followButton.hidden = YES;
    }
    
    //如果已登录判断是否关注菜谱发布人
    //[self getFollowedList];
    
    [[InternetManager sharedManager] currentUser:CurrentUserBaseId followedUser:self.cookbookDetail.creator.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        
        if (success) {
            NSInteger status = [obj[@"data"] integerValue];
            if (status == 1) {
                self.followButton.selected = YES;
            } else {
                self.followButton.selected = NO;
            }
            
            
        } else {
            self.followButton.selected = NO;
        }
        
    }];
    
    //是否已赞
    if ([self.cookbookDetail.praised isEqualToString:@"1"]) {
        NSLog(@"赞过了");
        self.praiseButton.selected = YES;
    } else {
        NSLog(@"未赞");
        self.praiseButton.selected = NO;
    }
    
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
            FoodsViewController* controller = [[FoodsViewController alloc] initWithFoods:self.cookbookDetail.foods delegate:self];
            self.foodsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"AddShoppingListCell" bundle:nil] forCellReuseIdentifier:@"Add shopping list cell"];
            [tableView registerNib:[UINib nibWithNibName:@"FoodCell" bundle:nil] forCellReuseIdentifier:@"Food cell"];
            [self.cookbookDetailCell.contentView addSubview:self.foodsTableView];
            break;
        }
        case CurrentContentTypeMethods:
        {
            self.stepsTableView = tableView;
            tableView.frame = CGRectMake(0, 0, Main_Screen_Width, [self getStepsViewHeight] + [self getSkillCellHeight]);
            tableView.tag = 6;
            StepsViewController* controller = [[StepsViewController alloc] initWithCookbookDetail:self.cookbookDetail delegate:self];
            self.stepsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"StepCell" bundle:nil] forCellReuseIdentifier:@"Step cell"];
            [tableView registerNib:[UINib nibWithNibName:@"OvenInfoCell" bundle:nil] forCellReuseIdentifier:@"Oven info cell"];
            [tableView registerNib:[UINib nibWithNibName:@"MethodCell" bundle:nil] forCellReuseIdentifier:@"Method cell"];
            [tableView registerNib:[UINib nibWithNibName:@"SkillCell" bundle:nil] forCellReuseIdentifier:@"Skill cell"];
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
            
//            if (self.comments.count == 0) {
//                Comment* comment = [[Comment alloc] init];
//                comment.content = @"这个菜谱真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！真好啊！";
//                comment.fromUser.userAvatar = @"http://d.hiphotos.baidu.com/image/pic/item/09fa513d269759ee2ea448afb1fb43166c22dfd9.jpg";
//                comment.commentTime = @"2014-12-31 10:47";
//                comment.fromUser.loginName = @"黄靖雯";
//                [self.comments addObject:comment];
//            
//            }
            
            CommentViewController* controller = [[CommentViewController alloc] initWithData:self.comments andController:self];
            self.commentsTableViewDataSource = controller;
            tableView.delegate = controller;
            tableView.dataSource = controller;
            [tableView registerNib:[UINib nibWithNibName:@"CommentCountCell" bundle:nil] forCellReuseIdentifier:@"Comment count cell"];
            [tableView registerNib:[UINib nibWithNibName:@"CommentListCell" bundle:nil] forCellReuseIdentifier:@"Comment list cell"];
            
//            if (IsLogin) {
                [self setupInputView];
//            }
            
            
            [self.tableView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
            
            [self addFooter];
            
            break;
            
        }
        default:
            break;
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.commentsTableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.commentPageIndex = 1;
        [vc loadComments];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.commentsTableView headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.commentsTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        vc.commentPageIndex++;
        [vc loadComments];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.commentsTableView footerEndRefreshing];
            
        });
        
    }];
    
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
    if (!self.isPreview) {
        [self loadComments];
    }
    [self getShoppinglist];
    
}

- (void)dealloc
{
    self.window = nil;
}

- (void)setupSubviews
{
    // 设置其他
    self.creatorAvatar.layer.masksToBounds = YES;
    self.creatorAvatar.layer.cornerRadius = self.creatorAvatar.height / 2.0;
    self.creatorAvatar.layer.borderWidth = 1;
    self.creatorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.tagsView.backgroundColor = [UIColor clearColor];
    
    self.learnButton.layer.cornerRadius = self.learnButton.height / 2 - 8;
    self.learnButton.layer.masksToBounds = YES;
    self.learnButton.backgroundColor = GlobalOrangeColor;
    
    self.cookbookDescLabel.textColor = RGB(105, 84, 89);
    
    [self.followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.followButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.followButton setBackgroundImage:[MyTool createImageWithColor:RGB(100, 170, 140)] forState:UIControlStateNormal];
    [self.followButton setBackgroundImage:[MyTool createImageWithColor:RGB(200, 200, 200)] forState:UIControlStateSelected];
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.cornerRadius = self.followButton.height / 2;
}

- (void)setupInputView
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0.0f,
                                                                  Main_Screen_Height - 40.0f,
                                                                  Main_Screen_Width,
                                                                  40.0f)];
    window.windowLevel = UIWindowLevelAlert;
    [window makeKeyAndVisible];
    self.window = window;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           window.bounds.size.width - 20.0f - 50.0f,
                                                                           30.0f)];
    self.commentTextField = textField;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.layer.borderColor = GlobalOrangeColor.CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
    textField.placeholder = @"请输入评论...";
    textField.font = [UIFont fontWithName:GlobalTextFontName size:12];
    textField.backgroundColor = RGB(250, 250, 250);
    [window addSubview:textField];
    window.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton addTarget:self action:@selector(didTapSend:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"确定" forState:UIControlStateNormal];
    [sendButton setTitleColor:GlobalOrangeColor forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:GlobalTextFontName size:15];
    
    sendButton.frame = CGRectMake(window.bounds.size.width - 50.0f,
                                  6.0f,
                                  40.0f,
                                  29.0f);
    [window addSubview:sendButton];

    
    window.hidden = YES;
    
    self.tableView.keyboardTriggerOffset = window.bounds.size.height;
    
    
    [self.cookbookDetailCell.contentView addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        
        NSLog(@"keyboardFrameInView y : %.2f", keyboardFrameInView.origin.y);
        CGRect windowFrame = window.frame;
        windowFrame.origin.y = keyboardFrameInView.origin.y - windowFrame.size.height + 64 + 50;
        window.frame = windowFrame;
        
    }];
    
}

- (void)hideKeyboard
{
    [self.cookbookDetailCell.contentView hideKeyboard];
    self.window.frame = CGRectMake(0.0f,
                                   Main_Screen_Height - 40.0f,
                                   Main_Screen_Width,
                                   40.0f);
}

- (void)didTapSend:(id)sender
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    if (self.commentTextField.text.length == 0) {
        [super showProgressErrorWithLabelText:@"评论不能为空" afterDelay:1];
        return;
    }
    
    if (self.lastCommentTime != nil) {
        
        NSTimeInterval inteval = [[NSDate date] timeIntervalSinceDate:self.lastCommentTime];
        if (inteval < 10) {
            [super showProgressErrorWithLabelText:@"你可以休息一会" afterDelay:1];
            return;
        }
        
    }
    
    
    NSLog(@"添加评论:%@", self.commentTextField.text);
    [self hideKeyboard];
    Comment* comment = [[Comment alloc] init];
    comment.content = self.commentTextField.text;

    comment.fromUser.userAvatar = [DataCenter sharedInstance].currentUser.userAvatar;
    comment.commentTime = @"刚刚";
    comment.fromUser.loginName = [DataCenter sharedInstance].currentUser.userName;
    
    [[InternetManager sharedManager] addCommentWithCookbookId:self.cookbookId
                                                andUserBaseId:CurrentUserBaseId
                                                   andComment:self.commentTextField.text
                                                     parentId:@"0"  //self.cookbookDetail.creator.ID      //nil
                                                     callBack:^(BOOL success, id obj, NSError *error) {
                                                         if (success) {
                                                             NSLog(@"评论成功");
                                                             self.commentTextField.text = @"";
                                                             
                                                             self.lastCommentTime = [NSDate date];
                                                             
                                                             [self.comments addObject:comment];
                                                             CGPoint point = self.commentsTableView.contentOffset;
                                                             [UIView animateWithDuration:0.3 animations:^{
                                                                 self.commentsTableView.contentOffset = CGPointMake(0, point.y + [comment getHeight]);
                                                             }
                                                                              completion:nil];
                                                             [UIView animateWithDuration:0.3 animations:^{
                                                                 self.commentsTableView.contentOffset = CGPointMake(0, point.y + [comment getHeight]);
                                                             } completion:^(BOOL finished) {
                                                                 
                                                             }];
                                                             [self.commentsTableView reloadData];
                                                             
                                                         } else {
                                                             NSLog(@"评论失败");
                                                             [super showProgressErrorWithLabelText:@"评论失败" afterDelay:1];
                                                             
                                                         }
                                                         [self.commentsTableView reloadData];
                                                     }];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置NavigationBar
    
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAMED(@"clear.png") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:IMAGENAMED(@"clear.png")];
    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && _iOS7OvenListFlag) {
        _iOS7OvenListFlag = NO;
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self showRightNavigationView:NO];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.rightNavigationView.alpha = 0.0;
    [self showRightNavigationView:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    [self.cookbookDetailCell.contentView removeKeyboardControl];
    self.navigationController.navigationBar.translucent = NO;
    
    [self hideKeyboard];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _lastContentOffsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.tag != 5) { // 不是滑动评论
        
        if (scrollView.contentOffset.y < self.headerView.height + self.praiseButton.bottom) {
            [self showRightNavigationView:NO];
        } else {
            [self showRightNavigationView:YES];
        }
        
        if (self.contentType == CurrentContentTypeComment) {
            NSLog(@"%f", scrollView.contentOffset.y);
            CGFloat height = self.headerView.height + self.cookbookTitleCell.height + self.cookbookDescCell.height + self.learnCookBtnCell.height - 20;
            if (IsLogin) {
                self.window.hidden = scrollView.contentOffset.y >= height ? NO : YES;
            }
            
        }
        
        if (scrollView.contentOffset.y > self.headerView.height - 64) {
            [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.translucent = NO;
            
        } else {
            [self.navigationController.navigationBar setBackgroundImage:IMAGENAMED(@"clear.png") forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.translucent = YES;
        }
        
        if (scrollView.contentOffset.y < _lastContentOffsetY)
        {
            //        NSLog(@"向下拉动");
            if (scrollView.contentOffset.y < 0) {
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self showRightNavigationView:NO];
            }
            
            if (self.contentType == CurrentContentTypeComment) {
                [self hideKeyboard];
            }
            
        } else if (scrollView.contentOffset.y > _lastContentOffsetY)
        {
            
            //        NSLog(@"向上拉动");
            if (self.contentType == CurrentContentTypeComment) {
                self.commentsTableView.scrollEnabled = YES;
  
            }
            
        }
        
        _lastContentOffsetY = scrollView.contentOffset.y;
        
    } else {    //滑动评论
        NSLog(@"%f", scrollView.contentOffset.y);
    }
    
    
}

- (void)showRightNavigationView:(BOOL)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rightNavigationView.alpha = show ? 1.0 : 0.0;
    }];
    if (show && self.rightNavigationView.hidden) {
        self.rightNavigationView.hidden = NO;
    }
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
                // 获取描述的高度
                return [self getDescCellHeight];
                break;
            case 2: // 新手学烘焙
                return 50;
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
                return MAX(minHeight, [self getStepsViewHeight] + [self getSkillCellHeight]);
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

- (CGFloat)getDescCellHeight
{
    CGFloat height = 17;
    
    height += [MyUtils getTextSizeWithText:self.cookbookDetail.desc andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTextFontName size:13.0f]} andTextWidth:Main_Screen_Width - 30].height;
    
    return height;
}

- (CGFloat)getStepsViewHeight
{
    CGFloat height = 0.0f;
    height += 44 + 67; //两个固定cell高度
    for (Step* step in self.cookbookDetail.steps) {
        height += 20; // 图片距离上边距
        height += (Main_Screen_Width - 54 - 26) * 7 / 12;   //图片宽高比位7:12
        height += 8; // 图片和Label的间距
        height += [MyUtils getTextSizeWithText:step.desc andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTitleFontName size:13.0f]} andTextWidth:Main_Screen_Width - 54 - 26].height; // 文字高度
        height += 8; //Label距离下边距
    }
    
    return height;
}

- (CGFloat)getSkillCellHeight
{
    // 技巧小贴士
    CGFloat height = 36 + 71;
    height += [MyUtils getTextSizeWithText:self.cookbookDetail.cookbookTip andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTitleFontName size:13.0f]} andTextWidth:Main_Screen_Width - 25 -17].height;
    return height;
}

#pragma mark - CookbookSectionHeaderDelegate

- (void)CookbookSectionView:(CookbookSectionHeaderView *)sectionHeader didTappedWithContentType:(CurrentContentType)type
{
    
    self.contentType = type;
    
    [self hideKeyboard];
    
    if (self.contentType != CurrentContentTypeComment) {
        self.window.hidden = YES;
    }
    
    CGFloat height = self.headerView.height + self.cookbookTitleCell.height + self.cookbookDescCell.height + self.learnCookBtnCell.height - 20;
    
    if (_lastContentOffsetY >= height && self.contentType == CurrentContentTypeComment && IsLogin) {
        self.window.hidden = NO;
    }
    
    for (UIView* view in self.cookbookDetailCell.contentView.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
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
            if (!IsLogin) {
                self.commentsTableView.frame = CGRectMake(0, 0, Main_Screen_Width, self.cookbookDetailCell.contentView.height);
            } else {
                self.commentsTableView.frame = CGRectMake(0, 0, Main_Screen_Width, self.cookbookDetailCell.contentView.height - 40);
            }
            
            [self.cookbookDetailCell.contentView addSubview:self.commentsTableView];
            
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

- (void)startCook
{
    _iOS7OvenListFlag = YES;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([DataCenter sharedInstance].myOvens.count > 1 || [DataCenter sharedInstance].myOvens.count == 0) {
        DeviceViewController* devicesController = [storyboard instantiateViewControllerWithIdentifier:@"DeviceViewController"];
        [self.navigationController pushViewController:devicesController animated:YES];
    } else {
        //只有1台的时候直接跳转到烤箱控制面板
        DeviceBoardViewController* deviceBoardController = [storyboard instantiateViewControllerWithIdentifier:@"DeviceBoardViewController"];
        deviceBoardController.currentOven = [[DataCenter sharedInstance].myOvens firstObject];
        [self.navigationController pushViewController:deviceBoardController animated:YES];
        
    }
    
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)follow:(UIButton *)sender
{
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    NSString* userID = CurrentUserBaseId;
    if (!sender.selected) {
        [[InternetManager sharedManager] addFollowWithUserBaseId:userID andFollowedUserBaseId:self.cookbookDetail.creator.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                [super showProgressCompleteWithLabelText:@"关注成功" afterDelay:1];
                sender.selected = YES;
            } else {
                [super showProgressErrorWithLabelText:@"关注失败" afterDelay:1];
                sender.selected = NO;
            }
        }];
    } else {
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userID andFollowedUserBaseId:self.cookbookDetail.creator.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                [super showProgressCompleteWithLabelText:@"取消关注" afterDelay:1];
                sender.selected = NO;
            } else {
                [super showProgressErrorWithLabelText:@"取消关注失败" afterDelay:1];
                sender.selected = YES;
            }
        }];
    }
 
}


/**
 *  赞菜谱
 *
 *  @param sender 赞
 */
- (IBAction)praiseCookbookTapped:(UIButton *)sender
{
    if (self.isPreview) {
        [super showProgressErrorWithLabelText:@"预览状态不可以赞喔" afterDelay:1];
        return;
    }
    
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    if (self.praiseButton.selected) { // 已赞
        
        [self cancelPraiseCookbook];
        
    } else { // 未赞
        
        [self praiseCookbook];
        
    }
    
}

- (IBAction)shareCookbookTapped:(UIButton *)sender
{
    [self shareCookbook];
}


- (IBAction)userAvatarTapped:(UITapGestureRecognizer *)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCenterViewController* personalViewController = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
    
    personalViewController.currentUserId = self.cookbookDetail.creator.userBaseId;
    [self.navigationController pushViewController:personalViewController animated:YES];
    
}

#pragma mark - AddShoppingListCellDelegate

- (void)getShoppinglist
{
    [[InternetManager sharedManager] getShoppingListWithUserBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
     
        if (success) {
            
            NSArray* arr = obj;
            self.shoppingListCount = arr.count;
            
        } else {
            [super showProgressErrorWithLabelText:@"添加失败" afterDelay:1];
        }
    }];
}

- (void)AddShoppingListWithCell:(AddShoppingListCell *)cell
{
    NSLog(@"保存到购物清单");
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    
    if (self.isPreview) {
        [super showProgressErrorWithLabelText:@"预览状态不可以添加喔" afterDelay:1];
        return;
    }
    
    //获取购物清单，保存数量不能超过10条
    if (self.shoppingListCount > 10) {
        [super showProgressErrorWithLabelText:@"清单里菜谱太多啦，删掉一些吧！" afterDelay:2];
        //return;
    }
    
    //构建购物清单对象
    NSString* userId = CurrentUserBaseId;
    ShoppingOrder* shoppingOrder = [[ShoppingOrder alloc] init];
    shoppingOrder.cookbookID = self.cookbookDetail.cookbookId;
    shoppingOrder.cookbookName = self.cookbookDetail.name;
    shoppingOrder.creatorId = userId;
    
    NSMutableArray* foods = [NSMutableArray array];
    for (Food* food in self.cookbookDetail.foods) {
        PurchaseFood* purchaseFood = [[PurchaseFood alloc] init];
        purchaseFood.index = food.index;
        purchaseFood.name = food.name;
        purchaseFood.desc = food.desc;
        purchaseFood.isPurchase = NO;
        [foods addObject:purchaseFood];
    }
    shoppingOrder.foods = foods;
    
    // 发送网络请求
    [[InternetManager sharedManager] saveShoppingOrderWithShoppingOrder:shoppingOrder callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            if (self.shoppingListCount <= 10) 
                [super showProgressCompleteWithLabelText:@"添加成功" afterDelay:1];
        } else {
            [super showProgressErrorWithLabelText:@"添加失败" afterDelay:1];
        }
    }];
    
}

- (IBAction)studyCookTapped:(UIButton *)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StudyCookViewController* studyController = [storyboard instantiateViewControllerWithIdentifier:@"StudyCookViewController"];
    [self.navigationController pushViewController:studyController animated:YES];
    
}


#pragma mark - 点赞、取消点赞和分享

- (void)praiseCookbook
{
    
    NSString* userID = CurrentUserBaseId;
    [[InternetManager sharedManager] praiseCookbookWithCookbookId:self.cookbookId userBaseId:userID callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            [super showProgressCompleteWithLabelText:@"菜谱点赞成功" afterDelay:1];
            self.praiseButton.selected = YES;
        } else {
            [super showProgressErrorWithLabelText:@"赞菜谱没有成功" afterDelay:1];
            self.praiseButton.selected = NO;
        }
    }];
    
}

- (void)cancelPraiseCookbook
{
    NSString* userID = CurrentUserBaseId;
    [[InternetManager sharedManager] cancelPraiseCookbook:self.cookbookId userBaseId:userID callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            [super showProgressCompleteWithLabelText:@"取消赞成功" afterDelay:1];
            self.praiseButton.selected = NO;
        } else {
            [super showProgressErrorWithLabelText:@"取消赞没有成功" afterDelay:1];
            self.praiseButton.selected = YES;
        }
    }];
}

- (void)shareCookbook
{
    if (self.isPreview) {
        [super showProgressErrorWithLabelText:@"预览状态不分享赞喔" afterDelay:1];
        return;
    }
    
//    if (!IsLogin) {
//        [super openLoginController];
//        return;
//    }
    
    NSLog(@"分享");
    // 构建分享内容
    NSString* shareText = [NSString stringWithFormat:@"海尔带你分享美食：%@，作者：%@", self.cookbookDetail.name, self.cookbookDetail.creator.userName];
    
    //由于调试时QQ未安装也显示了，所以这里对QQ进行单独判断
    NSArray* snsNames = [QQApi isQQInstalled] ? @[ UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ] : @[ UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:shareText shareImage:self.cookbookImageView.image shareToSnsNames:snsNames delegate:self];
    
}

#pragma mark - UMSocialDataDelegate & UMSocialUIDelegate

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    NSString* shareUrl = [BaseShareUrl stringByAppendingPathComponent:self.cookbookDetail.cookbookId];
    
    NSLog(@"platform: %@, shareUrl: %@", platformName, shareUrl);
    
    if ([platformName hasPrefix:@"wx"]) { //微信分享，只分享图片，分享到朋友圈时的连接为app下载地址
        
        socialData.shareImage = self.cookbookImageView.image;
        
        //在分享代码前设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
        //UMSocialWXMessageTypeImage 为纯图片类型
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
        
//        [UMSocialData defaultData].extConfig.title = self.cookbookDetail.desc;
        //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        
    } else if ([platformName hasPrefix:@"qq"]) {
//        socialData.shareImage = self.cookbookImageView.image;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    } else if ([platformName hasPrefix:@"sina"]) {
        
        NSString* sharePath = [@"http://115.29.8.251:8082/cookbook/detail" stringByAppendingPathComponent:self.cookbookDetail.cookbookId];
        sharePath = [sharePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"海尔带你分享美食：%@，作者：%@。\n%@", self.cookbookDetail.name, self.cookbookDetail.creator.userName, sharePath];
        
    }
    
//    [MobClick event:@"share" attributes:@{@"分享平台":platformName}];
    
}

- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);

    }
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        //分享成功送积分
        if (IsLogin) {
            
            [[InternetManager sharedManager] addPoints:ActiveUserScore userBaseId:CurrentUserBaseId callBack:^(BOOL success, id obj, NSError *error) {
                if (success) {
                    NSLog(@"分享成功送积分OK");
                    [super showProgressCompleteWithLabelText:@"分享成功 +20点心" afterDelay:1];
                }
            }];
            
        }
        
    }
}

@end









