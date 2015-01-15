//
//  BakeHouseCell.h
//  HaierOven
//
//  Created by dongl on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BakeHouseCell : UICollectionViewCell
@property (strong, nonatomic) UIImage *kitImage;
@property (copy, nonatomic) NSString *kitName;
@property (copy, nonatomic) NSString *kitPrice;
@end
