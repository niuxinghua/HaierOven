//
//  HowToUseControllerViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/26.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "HowToUseControllerViewController.h"
#import "PersonalCenterSectionView.h"
@interface HowToUseControllerViewController ()<PersonalCenterSectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UIImageView *cellimage;

@end

@implementation HowToUseControllerViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [super isBackButton];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:237.0f/255 green:237.0f/255 blue:237.0f/255 alpha:1.0];
    PersonalCenterSectionView *sectionview = [[PersonalCenterSectionView alloc]initWithFrame:CGRectMake(0, 0, self.headview.width, self.headview.height)];
    sectionview.sectionType = sectionHowToUse;
    sectionview.delegate = self;
    
    [self.headview addSubview:sectionview];
    
    // Do any additional setup after loading the view.
}

-(void)SectionType:(NSInteger)type{
    self.cellimage.image = type==1?IMAGENAMED(@"use.png"):IMAGENAMED(@"use2.png");
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Main_Screen_Width * 1.47;
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
