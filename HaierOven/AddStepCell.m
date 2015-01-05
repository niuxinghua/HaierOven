//
//  AddStepCell.m
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AddStepCell.h"
#import "AddStepDetailCell.h"
@interface AddStepCell ()<AddStepCellDetailDelegate>
@property (strong, nonatomic) IBOutlet UIButton *AddStepBtn;
@property (nonatomic)EditStyle editStyle;
@end
@implementation AddStepCell

- (void)awakeFromNib {

    self.editStyle = EditStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setAddStepTableView:(UITableView *)addStepTableView{
    _addStepTableView = addStepTableView;
    addStepTableView.delegate = self;
    addStepTableView.dataSource = self;
    [addStepTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddStepDetailCell class]) bundle:nil] forCellReuseIdentifier:@"AddStepDetailCell"];
}

-(void)setAddStepBtn:(UIButton *)AddStepBtn{
    _AddStepBtn = AddStepBtn;
    AddStepBtn.layer.cornerRadius = 10;
    AddStepBtn.layer.masksToBounds = YES;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.steps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddStepDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStepDetailCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.editStyle = self.editStyle;
    Step *step = self.steps[indexPath.row];
    cell.step = step;
//    cell.deleteBtn.tag = self.steps.count - 1 ;

    cell.stepIndexString = [NSString stringWithFormat:@"%@",step.index];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.addStepTableView.width*0.58;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark- 添加步骤
- (IBAction)AddStep:(id)sender {
    Step* step = [[Step alloc] init];
    step.index = [NSString stringWithFormat:@"%d", self.steps.count];
    
    [self.steps addObject:step];

    for (int i = 0; i<self.steps.count; i++) {
        Step* step = self.steps[i];
        step.index = [NSString stringWithFormat:@"%d",i+1];

    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.steps.count-1 inSection:0];
    [self.addStepTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate AddStepOfMainTableView:self.steps];
}

#pragma mark- 删除步骤
-(void)stepDetailCell:(AddStepDetailCell*)cell DeleteStepsAtIndex:(NSInteger)index{

    NSIndexPath* indexPath= [self.addStepTableView indexPathForCell:cell];
    
    [self.steps removeObjectAtIndex:indexPath.row];
    
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.addStepTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    for (int i = 0; i<self.steps.count; i++) {
//        [self.steps replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",i+1]];
        Step* step = self.steps[i];
        step.index = [NSString stringWithFormat:@"%d",i+1];
    }
    
    [self.addStepTableView reloadData];
    [self.delegate DeleteStepOfMainTableView:self.steps];

}

#pragma mark -
-(void)stepDetailCell:(AddStepDetailCell*)cell AddStepImage:(UIImageView *)imageview{
    NSIndexPath* indexPath = [self.addStepTableView indexPathForCell:cell];
    [self.delegate AddStepImage:imageview  withStepIndex:indexPath.row];
}
-(void)stepDetailCell:(AddStepDetailCell*)cell AddStepDescription:(UILabel *)label{
    NSIndexPath* indexPath = [self.addStepTableView indexPathForCell:cell];
    [self.delegate ImportStepDescription:label  withStepIndex:indexPath.row];
}
- (IBAction)DeleteStep:(id)sender {
    self.editStyle = self.editStyle ==EditStyleNone? EditStyleDelete:EditStyleNone;
    [self.addStepTableView reloadData];
}
@end
