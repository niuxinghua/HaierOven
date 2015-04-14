//
//  StudyCookViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookViewController.h"
#import "StudyCookCell.h"
#import "StudyDetailController.h"
@interface StudyCookViewController ()<StudyCookCellDelegate,StudyCookViewDelegate>
{
    BOOL      isfixed;
    NSInteger indexFiex;
    NSInteger indexSection;
}
@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIButton *tempBtn;
@property (strong, nonatomic) NSArray *detailArr;
@property (copy, nonatomic) NSString* currentMainMenu;
@end

@implementation StudyCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr=@[@"烘焙必备工具",@"烘焙材料",@"烘焙必备技法"];
    self.images = @[IMAGENAMED(@"fresh-group-1.png"),IMAGENAMED(@"fresh-group-2.png"),IMAGENAMED(@"fresh-group-3.png")];
    self.detailArr = @[
  @[@"测量工具",@"分离工具",@"搅拌工具",@"整形工具",@"成形工具",@"烘烤工具",@"切割工具"],
  @[@"粉类材料",@"膨大剂",@"油脂、芝士材料",@"糖类材料"],
  @[@"打发黄油",@"简易蛋糕制作要点",@"蛋白打发法",@"全蛋打发法",@"打发鲜奶油",@"面包制作流程",@"酥皮制作"]];
    indexFiex = 99;
    
    [MobClick event:@"learn_bake"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
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
    return self.arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.detailArr[indexPath.row];
    
    
   return  indexFiex==indexPath.row && isfixed? 80 + arr.count * 45+16:80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyCookCell" forIndexPath:indexPath];
    cell.details=self.detailArr[indexPath.row];
    cell.bkImage = self.images[indexPath.row];
    cell.title = self.arr[indexPath.row];
    cell.delegate = self;
    // Configure the cell...
    
    return cell;
}


-(void)fixedCell:(StudyCookCell *)cell{

    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    
    if (indexFiex!=index.row)
        self.tempBtn.selected = NO;
    
        indexFiex = index.row;
    cell.icon.selected = !cell.icon.selected;
    
    self.tempBtn = cell.icon;
    
    isfixed = cell.icon.selected;
//    if (self.tempBtn.tag != index.row)
//        self.tempBtn.selected = !self.tempBtn.selected;
//    
//    
//    isfixed = cell.icon.selected;
//    if (cell.icon.selected) {
//        indexFiex = index.row;
//        
//        self.tempBtn.tag = index.row;
//    }
    NSLog(@"%@", self.tempBtn.currentTitle);
    if (cell.icon.selected) {
        self.currentMainMenu = cell.title;
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Study baking"     // Event category (required)
                                                              action:[@"Menu_" stringByAppendingString:cell.title]  // Event action (required)
                                                               label:[@"Menu_" stringByAppendingString:cell.title]          // Event label
                                                               value:nil] build]];    // Event value
    }
    
    [self.tableView reloadData];

}

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Study baking"     // Event category (required)
                                                          action:@"back"  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
}

-(void)getSelectedView:(StudyCookView *)studycook{
    
    NSLog(@"%@", studycook.title);
    StudyDetailController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyDetailController"];
    detail.studyType = indexFiex;
    detail.toolIndex = studycook.tag;
    [self.navigationController pushViewController:detail animated:YES];
    
    NSLog(@"%@-%@", self.currentMainMenu, studycook.title);
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Study baking"     // Event category (required)
                                                          action:[@"Menu_" stringByAppendingString:self.currentMainMenu]  // Event action (required)
                                                           label:[NSString stringWithFormat:@"%@-%@", self.currentMainMenu, studycook.title]          // Event label
                                                           value:nil] build]];    // Event value
    
    
}

@end
