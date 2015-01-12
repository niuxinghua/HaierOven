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
@interface BakedHouseViewController ()<BakeHouseHeaderReusableViewDelegate>
@property (strong, nonatomic)UIWindow *myWindow;

@property (strong, nonatomic) NSArray *equipments;
@end

@implementation BakedHouseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setUpSubviews{
    self.myWindow = [UIWindow new];
    self.myWindow.backgroundColor = [UIColor whiteColor];
    self.myWindow.layer.cornerRadius = 5;
    self.myWindow.layer.borderColor = GlobalOrangeColor.CGColor;
    self.myWindow.layer.borderWidth = 1;
    self.myWindow.windowLevel = UIWindowLevelAlert;
    [self.myWindow makeKeyAndVisible];
    self.myWindow.userInteractionEnabled = YES;
    self.myWindow.hidden = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    CGPoint newLocation = [sectionFiexibleView convertPoint:location toView:sectionFiexibleView.superview.superview.superview];
    
    if (sender.selected==NO) {
        self.myWindow.frame = CGRectMake(newLocation.x, newLocation.y+64, sender.width, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.myWindow.frame = CGRectMake(newLocation.x, newLocation.y+64, sender.width, 200);
        } completion:^(BOOL finished) {
            sender.selected = YES;
            NSLog(@"下");
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.myWindow.frame = CGRectMake(newLocation.x, newLocation.y+64, sender.width,0);

        } completion:^(BOOL finished) {
            sender.selected = NO;
            NSLog(@"上");
        }];
    }

}



#define LABEL_H    26   //标签high
-(void)setEquipments:(NSArray *)equipments{
    _equipments = equipments;
    for (int i = 0; i<equipments.count; i++) {
        UILabel *label = [UILabel new];
        label.text = equipments[i];
        label.frame = CGRectMake(0, i*LABEL_H+8+50, 107, LABEL_H);
        [self.myWindow addSubview: label];
    }
}
@end
