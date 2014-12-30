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
@property int stepIndex;
@end
@implementation AddStepCell

- (void)awakeFromNib {
    self.stepIndex =1;
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
    
    return self.steps.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddStepDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddStepDetailCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.stepIndexString = [NSString stringWithFormat:@"%d",self.stepIndex];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.addStepTableView.width*0.58;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (IBAction)AddStep:(id)sender {
    self.stepIndex++;
    [self.steps addObject:@"鸡肉"];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.steps.count inSection:0];
    [self.addStepTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.delegate AddStepOfMainTableView:self.steps];
}

-(void)AddStepImage:(UIImageView *)imageview{
    [self.delegate AddStepImage:imageview];
}
-(void)AddStepDescription:(UILabel *)label{
    [self.delegate ImportStepDescription:label];
}
@end
