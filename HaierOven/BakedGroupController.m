//
//  BakedGroupController.m
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakedGroupController.h"
#import "PersonalCenterSectionView.h"
#import "MainViewNormalCell.h"
#import "BakeGroupAdviceCell.h"
@interface BakedGroupController ()<PersonalCenterSectionViewDelegate,BackGroupAdviceCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *follows;
@property (strong, nonatomic) NSArray *advices;
@property (strong, nonatomic) PersonalCenterSectionView* headerView;
@end
#define HeaderViewRate         0.1388888
#define CellImageRate   0.6
@implementation BakedGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    self.follows =@[@"关注",@"关注",@"关注",@"关注",@"关注"];
    self.advices = @[@"建议",@"建议",@"建议",@"建议",@"建议",@"建议",];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SetUpSubviews{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.backGroupType = BackGroupTypeFollowed;
    
    self.headerView = [[PersonalCenterSectionView alloc] initWithFrame:CGRectMake(0, 0, PageW, PageW*HeaderViewRate) ];
    self.headerView.sectionType = sectionFollow;
    self.headerView.delegate = self;

    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([BakeGroupAdviceCell class] ) bundle:nil] forCellReuseIdentifier:@"BakeGroupAdviceCell"];
}

#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.backGroupType ==BackGroupTypeAdvice?self.advices.count:self.follows.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  self.backGroupType ==BackGroupTypeAdvice?93:PageW*CellImageRate;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PageW*HeaderViewRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.backGroupType) {
        case BackGroupTypeFollowed:{
            NSString *cellIdentifier =@"MainViewNormalCell";
            MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            //    cell.cookbook = self.advices[indexPath.row];
            cell.AuthorityLabel.hidden = YES;
            return cell;
            break;
        }
            
        default:{
            NSString *cellIdentifier =@"BakeGroupAdviceCell";
            BakeGroupAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.delegate = self;
            //    cell.cookbook = self.advices[indexPath.row];
            return cell;
            break;
        }
    }
   
}

#define HeaderViewRate         0.1388888
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.headerView;
}

-(void)SectionType:(NSInteger)type{
    self.backGroupType = type;
}



-(void)setBackGroupType:(BackGroupType)backGroupType{
    _backGroupType = backGroupType;
    [self.tableview reloadData];
}

-(void)followed:(UIButton *)sender{
    sender.selected = !sender.selected;
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
