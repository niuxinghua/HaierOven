//
//  MainViewController.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MainViewController.h"
#import "CycleScrollView.h"
#import "MainViewNormalCell.h"
#import "FoodListViewController.h"
#import "CookbookDetailControllerViewController.h"
#import "MJRefresh.h"
#import "Tag.h"
#import "Cookbook.h"

#define AdvRate         0.5
#define ScrRate         0.1388888
#define CellImageRate   0.6
@interface MainViewController () <MainViewNormalCellDelegate,UIScrollViewDelegate>
//{
//    NSInteger _pageIndex;
//}

@property (strong, nonatomic) CycleScrollView *adCycleView;
@property (strong, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) IBOutlet UIScrollView *tagsScrollView;
@property (strong, nonatomic) IBOutlet UITableView *maintable;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property NSInteger pageIndex;
@property (strong, nonatomic) NSArray* cookbooks;

@end
//@synthesize pageIndex;

@implementation MainViewController
#pragma mark - 获取网络数据

- (void)loadTags
{
    [super showProgressHUDWithLabelText:@"正在加载" dimBackground:NO];
    [[InternetManager sharedManager] getTagsCallBack:^(BOOL success, id obj, NSError *error) {
        [super hiddenProgressHUD];
        if (success) {
            self.tags = obj;
            [self setupTagsScrollView];
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
            }
        }
    }];
}

- (void)loadCookbooks
{
    [[InternetManager sharedManager] getAllCookbooksWithPageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            self.cookbooks = obj;
            [self.maintable reloadData];
        } else {
            if (error.code == InternetErrorCodeConnectInternetFailed) {
                [super showProgressErrorWithLabelText:@"无网络" afterDelay:1];
            } else {
                [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
            }
        }
    }];
    
}

#pragma mark - 加载系列

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
    
    [self loadTags];
    
    [self loadAds];
    
    self.maintable.dataSource = self;
    self.maintable.delegate = self;
    
    [self loadCookbooks];
    
    [self addHeader];
    [self addFooter];
    
    // Do any additional setup after loading the view.
}


- (void)setupSubviews
{
    [self.maintable registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];

    
    self.adView.frame = CGRectMake(0, 0, PageW, PageW*(AdvRate+ScrRate));
    // 构建广告条
    self.adCycleView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, PageW, PageW*AdvRate) animationDuration:10];;
    self.adCycleView.pageControlMiddle = YES;
    [self.adView addSubview:self.adCycleView];
    
        
}

- (void)setupTagsScrollView
{
    self.tagsScrollView = [UIScrollView new];
    self.tagsScrollView.frame = CGRectMake(0, self.adCycleView.bottom, PageW, PageW*ScrRate);
    self.tagsScrollView.contentSize = CGSizeMake((PageW/5)*self.tags.count, self.tagsScrollView.height);
    [self.adView addSubview:self.tagsScrollView];
    
    
    for (int loop = 0 ; loop < self.tags.count ; loop++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Tag* tag = self.tags[loop];
        [btn setTitle:[NSString stringWithFormat:@"  %@", tag.name] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"orangepoint"] forState:UIControlStateNormal];
        btn.tag = loop;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:GlobalTextFontName size: 15.0];
        
        [btn addTarget:self action:@selector(SelectTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake((PageW-8)/5*loop+8,0,(PageW-8)/5, self.tagsScrollView.height);
        [self.tagsScrollView addSubview:btn];
    }
}

#pragma mark 点击tag方法
-(void)SelectTagBtn:(UIButton*)sender{
    FoodListViewController *foodlist = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodListViewController"];
    [self.navigationController pushViewController:foodlist animated:YES];
}
#pragma mark -


- (void)loadAds
{
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
    for (int i = 0; i < 5; ++i) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, PageW*AdvRate)];
        tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        tempLabel.text = [NSString stringWithFormat:@"第%d页", i+1];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.font = [UIFont italicSystemFontOfSize:35];
        tempLabel.textColor = [UIColor whiteColor];
        [viewsArray addObject:tempLabel];
    }
    

        self.adCycleView.totalPagesCount = ^NSInteger(void){
            return viewsArray.count;
        };
        self.adCycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            //            NSLog(@"fetchContentViewAtIndex");

            return viewsArray[pageIndex];
        };
        self.adCycleView.TapActionBlock = ^(NSInteger pageIndex){
            NSLog(@"点击了第%ld个",(long)pageIndex);
        };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.cookbooks.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier =@"MainViewNormalCell";
    MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = GlobalGrayColor;
    cell.delegate = self;
    
    cell.foodName.font = [UIFont fontWithName:GlobalTitleFontName size:17];
    cell.foodMakeFunction.font = [UIFont fontWithName:GlobalTextFontName size:11.5];
    cell.cookerName.font = [UIFont fontWithName:GlobalTextFontName size:11];
    
    cell.cookbook = self.cookbooks[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*CellImageRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Cookbook" bundle:nil];
    CookbookDetailControllerViewController* cookbookDetailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    cookbookDetailController.cookbook = self.cookbooks[indexPath.row];
    [self.navigationController pushViewController:cookbookDetailController animated:YES];
}


-(void)ChickPlayBtn:(id)cellClass{
    
    NSLog(@"播播播放");
}
-(void)ChickLikeBtn:(id)cellClass andBtn:(UIButton *)btn{
    
    btn.selected = btn.selected==YES? NO:YES;
    if (btn.selected ==YES) {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.2)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [btn.layer addAnimation:k forKey:@"SHOW"];
    }

    NSLog(@"赞赞赞");
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.maintable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        if (1) {
            vc.pageIndex = 1;
            [vc loadCookbooks];
        } else {
            [vc.maintable headerEndRefreshing];
            return;
        }
        
        
        // 加载数据，0.5秒后执行
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [vc.maintable reloadData];
        // 结束刷新
        [vc.maintable headerEndRefreshing];
        
        //        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.maintable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        if (1) {
            _pageIndex++;
            [vc loadCookbooks];
        } else {
            [vc.maintable footerEndRefreshing];
            return;
        }
        
        
        // 加载数据，0.5秒后执行
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [vc.maintable reloadData];
        // 结束刷新
        [vc.maintable footerEndRefreshing];
        
        //        });
        
    }];
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//
//{
//    
//    // 假设偏移表格高度的20%进行刷新
//    
//    
//    
//    if (!_isLoading) { // 判断是否处于刷新状态，刷新中就不执行
//    
//        
//        
//        // 取内容的高度：
//        
//        //    如果内容高度大于UITableView高度，就取TableView高度
//        
//        //    如果内容高度小于UITableView高度，就取内容的实际高度
//        
//        float height = scrollView.contentSize.height > self.maintable.frame.size.height ?self.maintable.frame.size.height : scrollView.contentSize.height;
//        
//        
//        
//        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) {
//            
//            NSLog(@"下拉刷新");
//            // 调用上拉刷新方法
//            
//        }
//        
//        
//        
//        if (- scrollView.contentOffset.y / self.maintable.frame.size.height > 0.2) {
//            
//            // 调用下拉刷新方法
//            NSLog(@"上拉刷新");
//
//        }
//    
//    }
//
//}

@end











