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
//    cell.deleteBtn.tag = self.steps.count - 1 ;
    cell.stepIndexString = self.steps[indexPath.row];
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
    [self.steps addObject:@"鸡肉"];

    for (int i = 0; i<self.steps.count; i++) {
        [self.steps replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.steps.count-1 inSection:0];
    [self.addStepTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate AddStepOfMainTableView:self.steps];
}
#pragma mark- 删除步骤
-(void)DeleteStepsAtIndex:(NSInteger)index{
    [self.steps removeObjectAtIndex:index];
    for (int i = 0; i<self.steps.count; i++) {
        [self.steps replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.addStepTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.addStepTableView reloadData];
    [self.delegate DeleteStepOfMainTableView:self.steps];

}

#pragma mark -
-(void)AddStepImage:(UIImageView *)imageview{
    [self.delegate AddStepImage:imageview];
}
-(void)AddStepDescription:(UILabel *)label{
    [self.delegate ImportStepDescription:label];
}
- (IBAction)DeleteStep:(id)sender {
    self.editStyle = self.editStyle ==EditStyleNone? EditStyleDelete:EditStyleNone;
    [self.addStepTableView reloadData];
}
@end
