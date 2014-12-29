//
//  CreatMneuController.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CreatMneuController.h"
#import "CoverCell.h"
#import "ChooseTagsCell.h"
#import "AutoSizeLabelView.h"
#import "CellOfAddFoodTable.h"
#import "AddFoodAlertView.h"
@interface CreatMneuController ()<AutoSizeLabelViewDelegate,CellOfAddFoodTableDelegate,AddFoodAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) AddFoodAlertView *addFoodAlertView;
@end
#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high

@implementation CreatMneuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
}

-(void)SetUpSubviews{
    
    self.tags =  @[@"烘焙",@"蒸菜",@"微波炉",@"巧克力",@"面包",@"饼干海鲜",@"有五个字呢",@"四个字呢",@"三个字呢",@"没规律呢",@"都能识别的呢",@"鱼",@"零食",@"早点",@"海鲜"];
    
    self.foods = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellOfAddFoodTable class]) bundle:nil] forCellReuseIdentifier:@"CellOfAddFoodTable"];
    
    
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 0, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.addFoodAlertView = [[AddFoodAlertView alloc]initWithFrame:CGRectMake(0, 0, PageW-30, 138)];
    self.addFoodAlertView.delegate = self;
    [self.myWindow addSubview:self.addFoodAlertView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row ==0) {
            CoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoverCell" forIndexPath:indexPath];
            return cell;
            
        }else if(indexPath.row ==1)  {
            ChooseTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseTagsCell" forIndexPath:indexPath];
            cell.tagsView.delegate = self;
            cell.tagsView.tags = self.tags;
            return cell;
            
        }else{
            CellOfAddFoodTable *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOfAddFoodTable" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.food = [self.foods mutableCopy];
            cell.delegate = self;

            return cell;
        }
    // Configure the cell...    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return PageW*0.598;
            break;
        case 1:
            return [self getHeight];
            break;
        default:
            return (PageW-16)*0.13*(self.foods.count+2)+51;
            break;
    }
}

-(void)reloadMainTableView:(NSMutableArray *)arr{
    self.foods = [arr mutableCopy];
    CGPoint point = self.tableView.contentOffset;

    [UIView animateWithDuration:0.3 animations:^{self.tableView.contentOffset = CGPointMake(0, point.y+(PageW-16)*0.13);
    }completion:nil];
    [self.tableView reloadData];
}

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 自动标签delegate
-(void)chooseTags:(UIButton*)btn{
    btn.selected = btn.selected ==YES?NO:YES;

    NSLog(@"%d",btn.tag);
}
#pragma mark-

-(float)getHeight{
    float leftpadding = 0;
    int line = 1;
    int count = 0;
    for (int i = 0; i<self.tags.count; i++) {
        float wide  =  [AutoSizeLabelView boolLabelLength:self.tags[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:14]}]+20;
        
        if (leftpadding+wide+PADDING_WIDE*count>PageW-60) {
            leftpadding=0;
            ++line;
            count = 0;
        }
        
        leftpadding +=wide;
        count++;
    }
    
    
    return (PADDING_HIGHT+LABEL_H)*line+75;

}

-(void)ImportAlertView:(UILabel *)label{
    self.addFoodAlertView.addFoodAlertType = label.tag;
    self.addFoodAlertView.label = label;
    self.myWindow.hidden = NO;
}
#pragma mark- AddFoodAlertView 弹出框delegate
-(void)Cancel{
    self.myWindow.hidden = YES;
}

-(void)ChickAlert:(UILabel *)label{
    self.myWindow.hidden = YES;
}
#pragma mark -
@end
