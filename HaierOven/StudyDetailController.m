//
//  StudyDetailController.m
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyDetailController.h"
#import "StudyDetailCell.h"
#import "StudyDetailFiexView.h"
#import "StudyCookPartOne.h"
@interface StudyDetailController ()<StudyDetailFiexViewDelegate>
{
    CGFloat fiexViewHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (strong, nonatomic) UIWindow *myWindow;
@property (strong, nonatomic) StudyDetailFiexView *fiexView;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) StudyCookPartOne *partOne;
@end

@implementation StudyDetailController
@synthesize toolIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    
}



-(void)setUpSubviews{
    self.myWindow = [UIWindow new];
    self.myWindow.frame = CGRectMake(0, 64, PageW, PageH);
    self.myWindow.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = YES;
    
    self.fiexView = [StudyDetailFiexView new];
    self.fiexView.backgroundColor    = [UIColor whiteColor];
    fiexViewHeight = self.datas.count*44+16;
    self.fiexView.frame = CGRectMake(25, 0, PageW-50, 0);
    self.fiexView.tools = self.datas;
    self.fiexView.delegate = self;
    [self.myWindow addSubview:self.fiexView];

    self.partOne = self.datas[toolIndex];
    [self.titleBtn setTitle:self.partOne.title forState:UIControlStateNormal];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.partOne.tools.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudyCookTools *tool = self.partOne.tools[indexPath.row];
    return [tool getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyDetailCell" forIndexPath:indexPath];
    cell.tools = self.partOne.tools[indexPath.row];
    // Configure the cell...
    
    return cell;
}


- (IBAction)fiexViewShow:(UIButton*)sender {
    if (sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.fiexView.frame = CGRectMake(25, 0, PageW-50, 0);
        }];
    }else{
        [UIView animateWithDuration:0.35 animations:^{
        self.fiexView.frame = CGRectMake(25, 0, PageW-50, fiexViewHeight);
    }];
    }
    self.myWindow.hidden = sender.selected;
    sender.selected = !sender.selected;
}

- (IBAction)TurnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadViewWithToolsIndex:(NSInteger)index{
    self.partOne = self.datas[index];
    [self.titleBtn setTitle:self.partOne.title forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.fiexView.frame = CGRectMake(25, 0, PageW-50, 0);

    }completion:^(BOOL finished) {
        self.myWindow.hidden = YES;
    }];

    toolIndex = index;
    [self.tableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.fiexView.frame = CGRectMake(25, 0, PageW-50, 0);
    }];
}





-(void)setStudyType:(StudyType)studyType{
    _studyType = studyType;
    switch (studyType) {
        case StudyTypeTools:
            [self initToolsDatas];
            break;
            
        default:
            break;
    }
}

-(void)initToolsDatas{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StudyCookPart_1" ofType:@"plist"];
    NSArray* arr = [NSArray arrayWithContentsOfFile:plistPath];
    
    self.datas = [NSMutableArray new];
    
    for (int i = 0; i<arr.count; i++) {
        StudyCookPartOne *study = [StudyCookPartOne new];
        study = [study GetStudyCookPartOne:arr[i]];
        [self.datas addObject:study];
    }    
}

@end
