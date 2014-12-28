//
//  CookbookDetailControllerViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CookbookDetailControllerViewController.h"
#import "CookbookSectionHeaderView.h"

@interface CookbookDetailControllerViewController ()

#pragma mark - headerView

@property (weak, nonatomic) IBOutlet UIImageView *cookbookImageView;

@property (weak, nonatomic) IBOutlet UIImageView *creatorAvatar;

@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;

#pragma mark - section 0

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookTitleCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDescCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *learnCookBtnCell;

#pragma mark - section 1

@property (weak, nonatomic) IBOutlet UITableViewCell *cookbookDetailCell;

@end

@implementation CookbookDetailControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    CookbookSectionHeaderView* headerView = [[CookbookSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 50)];

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

@end
