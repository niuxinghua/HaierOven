//
//  StepsViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "StepsViewController.h"
#import "MethodCell.h"
#import "OvenInfoCell.h"
#import "StepCell.h"

@interface StepsViewController ()

@property (strong, nonatomic) NSArray* steps;

@property (strong, nonatomic) CookbookDetail* cookbookDetail;

@property (weak, nonatomic) id <SkillCellDelegate> delegate;

@end

@implementation StepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCookbookDetail:(CookbookDetail*)cookbookDetail delegate:(id<SkillCellDelegate>) delegate
{
    if (self = [super init]) {
        self.steps = cookbookDetail.steps;
        self.cookbookDetail = cookbookDetail;
        self.delegate = delegate;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.steps.count + 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < 2) {
        return 44;
    } else if (indexPath.row < self.steps.count + 2) {
        return [self getHeightWithStep:self.steps[indexPath.row - 2]];
    } else {
        return [self getSkillCellHeight];
    }
    
    
}

- (CGFloat)getHeightWithStep:(Step*)step
{
    CGFloat height = 0.0f;
    
    height += 20; // 图片距离上边距
    height += (Main_Screen_Width - 54 - 26) * 7 / 12;   //图片宽高比位7:12
    height += 8; // 图片和Label的间距
    height += [MyUtils getTextSizeWithText:step.desc andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTitleFontName size:13.0f]} andTextWidth:Main_Screen_Width - 54 - 26].height; // 文字高度
    height += 8; //Label距离下边距
    
    return height;
}

- (CGFloat)getSkillCellHeight
{
    // 技巧小贴士
    CGFloat height = 36 + 71;
    height += [MyUtils getTextSizeWithText:self.cookbookDetail.cookbookTip andTextAttribute:@{NSFontAttributeName : [UIFont fontWithName:GlobalTitleFontName size:13.0f]} andTextWidth:Main_Screen_Width - 25 -17].height;
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        MethodCell* methodCell = [tableView dequeueReusableCellWithIdentifier:@"Method cell" forIndexPath:indexPath];
        return methodCell;
    } else if (indexPath.row == 1) {
        OvenInfoCell* ovenCell = [tableView dequeueReusableCellWithIdentifier:@"Oven info cell" forIndexPath:indexPath];
        ovenCell.oven = self.cookbookDetail.oven;
        return ovenCell;
    } else if (indexPath.row >= 2 && indexPath.row < self.steps.count + 2) {
        StepCell* stepCell = [tableView dequeueReusableCellWithIdentifier:@"Step cell" forIndexPath:indexPath];
        stepCell.step = self.steps[indexPath.row - 2];
        return stepCell;
        
    } else {
        
        SkillCell* skillCell = [tableView dequeueReusableCellWithIdentifier:@"Skill cell" forIndexPath:indexPath];
        skillCell.delegate = self.delegate;
        skillCell.skillLabel.text = [self.cookbookDetail.cookbookTip isEqualToString:@"(null)"] ? @"无" : self.cookbookDetail.cookbookTip;
        return skillCell;
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
