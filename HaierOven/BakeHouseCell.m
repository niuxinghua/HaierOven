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
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation BakeHouseCell
//-(void)setKitImage:(UIImage *)kitImage{
//    _kitImage = kitImage;
//    self.image.image = kitImage;
//}
//-(void)setKitName:(NSString *)kitName{
//    _kitName = kitName;
//    self.label.text = kitName;
//}
//
//-(void)setKitPrice:(NSString *)kitPrice{
//    _kitPrice = kitPrice;
//    self.priceLabel.text = kitPrice;
//}

- (void)setProduct:(Equipment *)product
{
    _product = product;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:product.imagePath] placeholderImage:IMAGENAMED(@"mf.png")];
    
    self.priceLabel.text = product.price;
    self.label.text = product.name;
    
    
}

@end
