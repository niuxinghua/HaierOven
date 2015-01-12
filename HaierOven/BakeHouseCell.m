//
//  BakeHouseCell.m
//  HaierOven
//
//  Created by dongl on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BakeHouseCell.h"
@interface BakeHouseCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation BakeHouseCell
-(void)setKitImage:(UIImage *)kitImage{
    _kitImage = kitImage;
    self.image.image = kitImage;
}
-(void)setKitName:(NSString *)kitName{
    _kitName = kitName;
    self.label.text = kitName;
}
@end
