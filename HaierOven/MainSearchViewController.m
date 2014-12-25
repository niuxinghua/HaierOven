//
//  MainSearchViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MainSearchViewController.h"
#import "SearchView.h"
#import "SearchTableCell.h"
#import "RecommendTagView.h"
#import "FoodListViewController.h"
@interface MainSearchViewController ()<searchViewDelegate,RecommendTagViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic)  UILabel *notfFindLabel;
@property (strong, nonatomic) UIView *recommendTagsView;
@property (strong, nonatomic) NSArray *recommendTag;
@end

@implementation MainSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initFakeData];
        
    }
    return self;
}
-(void)initFakeData{
    self.recommendTag = @[@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签",@"推荐标签"];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpSubView];
        // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:UIColorFromRGB(0xefefef)]  forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)setUpSubView{
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.hidden = YES;
    self.table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = GlobalGrayColor;
    SearchView *searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, PageW-25, 35)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchView];
    searchView.delegate = self;
    [self addObserver:self forKeyPath:@"self.table.hidden" options:NSKeyValueObservingOptionNew context:NULL];

    
//  构建搜索无结果label
    self.notfFindLabel = [UILabel new];
    self.notfFindLabel.frame = CGRectMake(20, 30, PageW-40, 30);
    self.notfFindLabel.numberOfLines = 0;
    self.notfFindLabel.font = [UIFont fontWithName:GlobalTextFontName size:16];
    [self.view addSubview:self.notfFindLabel];

//  构建推荐标签view
    self.recommendTagsView  = [UIView new];
    self.recommendTagsView.frame = CGRectMake(0, 0, PageW, PageH);
    self.recommendTagsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recommendTagsView];
    
    int x = 0; int y = 0;
    for (int i = 0; i<self.recommendTag.count; i++) {
        RecommendTagView *RTV = [[RecommendTagView alloc]initWithFrame:CGRectMake(PageW/3*x, PageW/3/12*5*y, PageW/3, PageW/3/12*5)];
        RTV.delegate = self;
        x++;
        y=x==3?y+1:y;
        x=i%3==0&&i!=0?0:x;
        [RTV.tagbtn setTitle:self.recommendTag[i] forState:UIControlStateNormal];
        [self.recommendTagsView addSubview:RTV];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor]  forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SearchDelagate
-(void)TouchUpInsideCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)StartReach:(UITextField *)searchTextFailed{
    self.table.hidden = NO;
}

-(void)Cancel{
    self.table.hidden = YES;
}
#pragma mark-
#pragma mark 点击推荐按钮delegate
-(void)TouchUpTag:(id)tag{
    FoodListViewController *foodlist = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodListViewController"];
    [self.navigationController pushViewController:foodlist animated:YES];

    NSLog(@"跳跳跳");
}
#pragma mark-
#pragma mark TableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *cellIdentifier =@"recent";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }else{
        NSString *cellIdentifier =@"SearchTableCell";
        SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 35;
    }else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodListViewController *foodlist = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodListViewController"];
    [self.navigationController pushViewController:foodlist animated:YES];
}
#pragma mark-

#pragma mark  监听table.hidden
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"self.table.hidden"]) {
        self.recommendTagsView.hidden = self.table.hidden ==NO?YES:NO;
        if (self.recommendTagsView.hidden ==YES) {
            [self.view insertSubview:self.table aboveSubview:self.recommendTagsView];
        }else{
        [self.view insertSubview:self.table belowSubview:self.recommendTagsView];
        }
    }
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.table.hidden"];
}

#pragma mark-
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
