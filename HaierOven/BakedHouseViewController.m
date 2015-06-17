//
//  BakedHouseViewController.m
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakedHouseViewController.h"
#import "BakeHouseCell.h"
#import "BakeHouseHeaderReusableView.h"
#import "FiexibleView.h"
#import "MJRefresh.h"
#import "WebViewController.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

typedef NS_ENUM(NSInteger, ProductCategory) {
    ProductCategoryAll    = 0,  //所有
    ProductCategoryModel,       //模具
    ProductCategoryFood,        //食材
    ProductCategoryProduct,     //成品
    
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeTime    = 1,    //时间
    SortTypeHot,            //热度
   
    
};

@interface BakedHouseViewController ()<BakeHouseHeaderReusableViewDelegate,FiexibleViewDelegate>
{
    CGFloat fiexViewHegih;
    CGFloat fiexViewY;
}
@property (strong, nonatomic)FiexibleView *fiexView;
@property (strong, nonatomic)NSArray *equipments;
@property (strong, nonatomic)UIButton *tempFiexibleBtn;

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) ProductCategory productCategory;
@property (nonatomic) SortType sortType;

@property (weak, nonatomic) UITextField* searchTextField;

@property (strong, nonatomic) NSMutableArray* products;

@end

#define LABEL_H    38   //标签high

@implementation BakedHouseViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.pageIndex = 1;
        self.productCategory = ProductCategoryAll;
        self.sortType = SortTypeHot;
        self.products = [NSMutableArray array];
    }
    return self;
}

- (void)loadProducts
{
    //统计页面加载耗时
    UInt64 startTime=[[NSDate date]timeIntervalSince1970]*1000;
    if (_pageIndex == 1) {
        [super showProgressHUDWithLabelText:@"请稍候..." dimBackground:NO];
    }
    [[InternetManager sharedManager] getProductsWithCategory:self.productCategory
                                                    sortType:self.sortType
                                                   pageIndex:_pageIndex
                                                     keyword:self.searchTextField.text
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        [super hiddenProgressHUD];
                                                        if (success) {
                                                            
                                                            NSArray* arr = obj;
                                                            if (arr.count < PageLimit && _pageIndex != 1) {
                                                                [self.collectionView removeFooter];
                                                            }
                                                            if (_pageIndex == 1) {
                                                                if (arr.count == 0) {
                                                                    [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
                                                                    [self.collectionView removeFooter];
                                                                }
                                                                self.products = obj;
                                                            } else {
                                                                [self.products addObjectsFromArray:arr];
                                                            }
                                                            
                                                            [self.collectionView reloadData];
                                                            
                                                            UInt64 endTime=[[NSDate date]timeIntervalSince1970]*1000;
                                                            [uAnalysisManager onActivityResumeEvent:((long)(endTime-startTime)) withModuleId:@"烘焙屋页面"];
                                                            
                                                        } else {
                                                            NSLog(@"获取失败");
                                                            [super showProgressErrorWithLabelText:@"加载失败" afterDelay:1];
                                                        }
                                                        
                                                        
                                                    }];
    
    
}

#pragma mark - 新消息标记及移除标记

- (void)updateMarkStatus:(NSNotification*)notification
{
    NSDictionary* countDict = notification.userInfo;
    NSInteger count = [countDict[@"count"] integerValue];
    if (count > 0) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
}

- (void)markNewMessage
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //小圆点
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(-8, -5, 10, 10)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.height / 2;
    label.backgroundColor = [UIColor redColor];
    
    //添加到button
    [liebiaoBtn addSubview:label];
    self.navigationItem.leftBarButtonItem = liebiao;
    
}

- (void)deleteMarkLabel
{
    //拿到左侧栏按钮
    UIBarButtonItem* liebiao = self.navigationItem.leftBarButtonItem;
    UIButton* liebiaoBtn = (UIButton*)liebiao.customView;
    liebiaoBtn.clipsToBounds = NO;
    
    //移除小圆点Label
    for (UIView* view in liebiaoBtn.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    //重新赋值leftBarButtonItem
    self.navigationItem.leftBarButtonItem = liebiao;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    
     [self addHeader];
     [self addFooter];
    
    [self loadProducts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMarkStatus:) name:MessageCountUpdateNotification object:nil];
    if ([DataCenter sharedInstance].messagesCount > 0 && IsLogin) {
        [self markNewMessage];
    } else {
        [self deleteMarkLabel];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        vc.pageIndex = 1;
        [vc loadProducts];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        
        vc.pageIndex ++;
        [vc loadProducts];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.collectionView footerEndRefreshing];
            
        });
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setUpSubviews{
    self.equipments =@[@"全部",@"烘焙模具",@"烘焙食材",@"烘焙成品"];
    fiexViewHegih = 10+20+(LABEL_H*self.equipments.count);
    self.fiexView = [[FiexibleView alloc]initWithFrame:CGRectZero];
    self.fiexView.equipments = self.equipments;
    self.fiexView.backgroundColor = [UIColor clearColor];
    self.fiexView.delegate = self;
    UITapGestureRecognizer *packUp = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(packUpFiex)];
    [self.fiexView addGestureRecognizer:packUp];
    [self.view addSubview:self.fiexView];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BakeHouseHeaderReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Bake house header view" forIndexPath:indexPath];
        self.searchTextField = header.searchTextField;
        
        header.delegate = self;
        return header;
    } else {
        return [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    }
}

/* 定义每个UICollectionView 的大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(Main_Screen_Width / 2 - 32, Main_Screen_Width / 2 - 32);
}

/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 10, 15);//上 左 下 右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BakeHouseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BakeHouseCell" forIndexPath:indexPath];
    // Configure the cell
//    cell.kitImage = IMAGENAMED(@"QQQ.png");
//    cell.kitName = @"16寸面包摸具";
//    cell.backgroundColor = [UIColor yellowColor];
    
    cell.product = self.products[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController* webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Web view controller"];
    
    Equipment* selectedProduct = self.products[indexPath.row];
    
    webViewController.titleText = selectedProduct.name;
    webViewController.webPath = selectedProduct.url;
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)GetfiexibleBtnSelected:(UIButton *)sender andUIView:(SectionFiexibleView *)sectionFiexibleView{

    CGPoint location = sectionFiexibleView.frame.origin;

    CGPoint newLocation = [sectionFiexibleView convertPoint:location toView:sectionFiexibleView.superview.superview];
    
    self.tempFiexibleBtn = sender;
    fiexViewY = newLocation.y;
    
    if (sender.selected==NO){
        if (self.collectionView.contentOffset.y!=0) {
            [self.collectionView setContentOffset:CGPointMake(0, 0)];
        }
        [self fiexViewDown];
    } else
        [self fiexViewUp];
}



#pragma mark - 获取点击label

-(void)tapLabel:(UILabel *)label{
    NSLog(@"%@",self.equipments[label.tag]);
    NSString* categoryName = self.equipments[label.tag];
    [self.tempFiexibleBtn setTitle:label.text forState:UIControlStateNormal];
    [self.tempFiexibleBtn setTitle:label.text forState:UIControlStateHighlighted];
    [self fiexViewUp];
    
    if ([categoryName isEqualToString:@"全部"]) {
        self.productCategory = ProductCategoryAll;
    } else if ([categoryName isEqualToString:@"烘焙模具"]) {
        self.productCategory = ProductCategoryModel;
    } else if ([categoryName isEqualToString:@"烘焙食材"]) {
        self.productCategory = ProductCategoryFood;
    } else if ([categoryName isEqualToString:@"烘焙成品"]) {
        self.productCategory = ProductCategoryProduct;
    }
    self.pageIndex = 1;
    [self loadProducts];
}

#pragma mark - BakeHouseHeaderReusableViewDelegate

-(void)GetNeedEquipmentType:(NSInteger)type{
    NSLog(@"%d",type);
    [self fiexViewUp];
    
    if (type == 1) {
        self.sortType = SortTypeHot;
    } else {
        self.sortType = SortTypeTime;
    }
    self.pageIndex = 1;
    [self loadProducts];
}

-(void)GetSearchKeyWord:(NSString *)string{
    NSLog(@"%@",string);
    self.pageIndex = 1;
    [self loadProducts];
}

/**
 *  点击搜索按钮
 */
- (void)cancelSearch
{
    //self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    [self loadProducts];
}

/**
 *  取消搜索
 */
- (void)deleteSearch
{
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    [self loadProducts];
}

#pragma mark- 动画

-(void)packUpFiex{
    [self fiexViewUp];
}
-(void)fiexViewUp{
    self.collectionView.scrollEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.fiexView.frame = CGRectMake(12, fiexViewY, self.tempFiexibleBtn.width, 0);
        self.fiexView.imageFrame = CGRectMake(0, 5, self.tempFiexibleBtn.width, 0);
        
    } completion:^(BOOL finished) {
        self.tempFiexibleBtn.selected = NO;
    }];

}
-(void)fiexViewDown{
    self.fiexView.frame = CGRectMake(12, fiexViewY, self.tempFiexibleBtn.width, 0);
    self.fiexView.imageFrame =CGRectMake(0, 5, self.tempFiexibleBtn.width, 0);
    self.collectionView.scrollEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.fiexView.frame = CGRectMake(12, fiexViewY, self.tempFiexibleBtn.width, fiexViewHegih);
        self.fiexView.imageFrame = CGRectMake(0, 5, self.tempFiexibleBtn.width, fiexViewHegih-5);
        
    } completion:^(BOOL finished) {
        self.tempFiexibleBtn.selected = YES;
    }];
}


- (IBAction)search:(id)sender {
    
    MainSearchViewController* search = [self.storyboard instantiateViewControllerWithIdentifier:@"Search view controller"];
    
    [self.navigationController pushViewController:search animated:YES];
    
}

- (IBAction)addCookbook:(id)sender {
    
    if (IsLogin) {
        UpLoadingMneuController* upload = [self.storyboard instantiateViewControllerWithIdentifier:@"UpLoadingMneuController"];
        [self.navigationController pushViewController:upload animated:YES];
    } else {
        [super openLoginController];
    }
    
}

@end
