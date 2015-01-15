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


typedef NS_ENUM(NSInteger, ProductCategory) {
    ProductCategoryAll    = 0,  //所有
    ProductCategoryModel,       //模具
    ProductCategoryFood,        //食材
    ProductCategoryProduct,     //成品
    
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeTime    = 0,    //时间
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
    }
    return self;
}

- (void)loadProductsWithKeyword:(NSString*)keyword
{
    
    [[InternetManager sharedManager] getProductsWithCategory:self.productCategory
                                                    sortType:self.sortType
                                                   pageIndex:_pageIndex
                                                     keyword:keyword
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        
                                                        if (success) {
                                                            
                                                            
                                                            
                                                        } else {
                                                            NSLog(@"获取失败");
                                                        }
                                                        
                                                        
                                                    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    
    [self loadProductsWithKeyword:self.searchTextField.text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setUpSubviews{
    self.equipments =@[@"全部",@"烘焙器材",@"烘焙食材",@"烘焙磨具"];
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
    return 10;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BakeHouseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BakeHouseCell" forIndexPath:indexPath];
    // Configure the cell
//    cell.kitImage = IMAGENAMED(@"QQQ.png");
//    cell.kitName = @"16寸面包摸具";
//    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

-(void)GetfiexibleBtnSelected:(UIButton *)sender andUIView:(SectionFiexibleView *)sectionFiexibleView{

    CGPoint location = sectionFiexibleView.frame.origin;

    CGPoint newLocation = [sectionFiexibleView convertPoint:location toView:sectionFiexibleView.superview.superview];
    
    self.tempFiexibleBtn = sender;
    fiexViewY = newLocation.y;
    
    if (sender.selected==NO){
        if (self.collectionView.contentOffset.y==0) {
            [self fiexViewDown];
        }
    }else
        [self fiexViewUp];
}



#pragma mark - 获取点击label
-(void)tapLabel:(UILabel *)label{
    NSLog(@"%@",self.equipments[label.tag]);
    [self.tempFiexibleBtn setTitle:label.text forState:UIControlStateNormal];
    [self.tempFiexibleBtn setTitle:label.text forState:UIControlStateHighlighted];
    [self fiexViewUp];
}

#pragma mark - BakeHouseHeaderReusableViewDelegate
-(void)GetNeedEquipmentType:(NSInteger)type{
    NSLog(@"%d",type);
    [self fiexViewUp];
}

-(void)GetSearchKeyWord:(NSString *)string{
    NSLog(@"%@",string);
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


@end
