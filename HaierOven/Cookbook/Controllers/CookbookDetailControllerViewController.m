//
//  CookbookDetailControllerViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookDetailControllerViewController.h"
#import "CookbookSectionHeaderView.h"

@interface CookbookDetailControllerViewController () <UIScrollViewDelegate>
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

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDescCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *learnCookBtnCell;

#pragma mark - section 1

@property (strong, nonatomic) CookbookSectionHeaderView* sectionHeaderView;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDetailCell;

@end

@implementation CookbookDetailControllerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.sectionHeaderView = [[CookbookSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50) andCurrentContentType:CurrentContentTypeFoods];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews
{
    // 设置NavigationBar
    [self.navigationController.navigationBar setBackgroundImage:IMAGENAMED(@"clear.png") forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
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
        NSLog(@"table row count: %d", 3);
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
        return Main_Screen_Height - 64 - 50; //屏幕高度 - NavigationBar高度 - 状态栏高度 - SectionHeaderView高度
    }
    
    return 0;
    
}

#pragma mark - 按钮响应事件

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
