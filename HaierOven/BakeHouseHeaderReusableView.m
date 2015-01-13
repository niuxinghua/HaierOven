//
//  BakeHouseHeaderReusableView.m
//  HaierOven
//
//  Created by dongl on 15/1/12.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakeHouseHeaderReusableView.h"
#import "PersonalCenterSectionView.h"
#import "SearchView.h"
#import "SectionFiexibleView.h"
@interface BakeHouseHeaderReusableView()<PersonalCenterSectionViewDelegate,searchViewDelegate,SectionFiexibleViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *sectionSearchView;
@property (strong, nonatomic) IBOutlet UIView *sectionScrollView;
@property (strong, nonatomic) IBOutlet UIView *sectionFliexView;

@end
@implementation BakeHouseHeaderReusableView

-(void)awakeFromNib{
    [self initSectionView];
    [self initSearchView];
    [self initFiexlibleView];

}
//主动调用new 或者alloc init
-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self ==[super initWithCoder:aDecoder]) {
//        [self initSectionView];
//        [self initSearchView];
    }
    return self;
}


-(void)initSearchView{
//    PageW-25, 35
    SearchView *search = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, self.sectionSearchView.width-25, 30)];
    search.searchTextFailed.placeholder = @"请搜索你的烘焙装备....";
    search.delegate = self;
    search.center = self.sectionSearchView.center;
    [self.sectionSearchView addSubview:search];
}
-(void)initSectionView{
    PersonalCenterSectionView * scroll = [[PersonalCenterSectionView alloc]initWithFrame:CGRectMake(0, 0, self.sectionScrollView.width, self.sectionScrollView.height)];
    scroll.sectionType = sectionBakeHouse;
    scroll.backgroundColor = [UIColor clearColor];
    scroll.delegate = self;
    [self.sectionScrollView addSubview:scroll];
}

-(void)initFiexlibleView{
    SectionFiexibleView *fiex = [[SectionFiexibleView alloc]initWithFrame:CGRectMake(12, self.sectionFliexView.height/2-13, 100, 24)];
    fiex.delegate = self;
//    fiex.center = self.sectionFliexView.center;
    [self.sectionFliexView addSubview:fiex];
}


#pragma mark - 搜索栏回调方法
-(void)TouchUpInsideCancelBtn{

}

-(void)StartReach:(UITextField*)searchTextFailed{

}

-(void)Cancel{

}

- (void)textFieldTextChanged:(NSString*)text{

}

-(void)TouchUpInsideDone:(NSString *)string{
    [self.delegate GetSearchKeyWord:string];
}


#pragma mark - 显示热门还是最新
-(void)SectionType:(NSInteger)type{
    [self.delegate GetNeedEquipmentType:type];
}


#pragma  mark -提示controller下拉框显示状态
-(void)GetfiexibleBtnSelected:(UIButton *)sender
                    andUIView:(SectionFiexibleView *)sectionFiexibleView
{
    [self.delegate GetfiexibleBtnSelected:sender andUIView:sectionFiexibleView];
}

@end
