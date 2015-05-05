//
//  MainViewNormalCell.m
//  HaierOven
//
//  Created by dongl on 14/12/17.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "MainViewNormalCell.h"
#import "CookbookDetailControllerViewController.h"
#import "CBImageCompressor.h"

@interface MainViewNormalCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MainViewNormalCell

- (void)awakeFromNib {
    self.bottomOrangeView.backgroundColor = [UIColor clearColor];
    self.avater.layer.cornerRadius = self.avater.frame.size.height/2;
    self.avater.layer.masksToBounds = YES;
    self.avater.userInteractionEnabled = YES;
    [self.avater.layer setBorderWidth:1.5]; //边框宽度
    [self.avater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
    
    self.cookStarImageView.hidden = YES;
    
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.masksToBounds = YES;
    
    // 设置文本阴影
    self.goodCountLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.6);
    self.goodCountLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.timeLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.6);
    self.timeLabel.shadowOffset = CGSizeMake(1.0, 1.0);
//    self.goodCountLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.goodCountLabel.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    
    
// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCookbook:(Cookbook *)cookbook
{
    _cookbook = cookbook;
    //[self resetCell];
    
    
    @try {
        self.AuthorityLabel.hidden = YES;
        self.cookStarImageView.hidden = YES;
        
        self.goodCountLabel.text = cookbook.praises;
        
        [self.MainCellFoodBackground sd_setImageWithURL:[NSURL URLWithString:cookbook.coverPhoto] placeholderImage:[DataCenter sharedInstance].placeHolder];
        
//        self.MainCellFoodBackground.image = [DataCenter sharedInstance].placeHolder;
//        dispatch_queue_t queue = dispatch_queue_create("MainDownloadImage.queue", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(queue, ^{
//            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:cookbook.coverPhoto]];
//            UIImage* image = [UIImage imageWithData:data];
//            [CBImageCompressor compressImage:image limitSize:512*1024*6 maxSide:400 completion:^(NSData *data) {
//                UIImage* compressedImage = [UIImage imageWithData:data];
//                self.MainCellFoodBackground.image = compressedImage;
//            }];
//        });

//        self.MainCellFoodBackground.image = [DataCenter sharedInstance].placeHolder;
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:cookbook.coverPhoto]
//                              options:0
//                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                 // progression tracking code
//                             }
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                if (image) {
//                                    // do something with image
//                                    [CBImageCompressor compressImage:image limitSize:512*1024*6 maxSide:400 completion:^(NSData *data) {
//                                        UIImage* compressedImage = [UIImage imageWithData:data];
//                                        self.MainCellFoodBackground.image = compressedImage;
//                                    }];
//
//                                }
//                            }];
        
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:cookbook.coverPhoto done:^(UIImage *image, SDImageCacheType cacheType) {
//            if (image) {
//                [CBImageCompressor compressImage:image limitSize:512*1024*6 maxSide:400 completion:^(NSData *data) {
//                    UIImage* compressedImage = [UIImage imageWithData:data];
//                    self.MainCellFoodBackground.image = compressedImage;
//                }];
//
//            } else {
//                
//                self.MainCellFoodBackground.image = [DataCenter sharedInstance].placeHolder;
//                dispatch_queue_t queue = dispatch_queue_create("MainDownloadImage.queue", DISPATCH_QUEUE_SERIAL);
//                dispatch_async(queue, ^{
//                    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:cookbook.coverPhoto]];
//                    UIImage* image = [UIImage imageWithData:data];
//                    [[SDImageCache sharedImageCache] storeImage:image forKey:cookbook.coverPhoto];
//                    [CBImageCompressor compressImage:image limitSize:512*1024*6 maxSide:400 completion:^(NSData *data) {
//                        UIImage* compressedImage = [UIImage imageWithData:data];
//                        self.MainCellFoodBackground.image = compressedImage;
//                    }];
//                });
//            }
//        }];
        
        // 判断是否是官方菜谱
        if ([cookbook.creator.userLevel isEqualToString:@"1"] || [cookbook.creator.userLevel isEqualToString:@"2"]) {
            self.cookStarImageView.hidden = NO;
        }
        self.AuthorityLabel.hidden = !cookbook.isAuthority; // 只有userLevel为1才显示“官方菜谱”
        
        [self.avater sd_setImageWithURL:[NSURL URLWithString:cookbook.creator.avatarPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        
        self.foodName.text = cookbook.name;
        
        if (cookbook.desc.length == 0 || [cookbook.desc isEqualToString:@"(null)"]) {
            self.foodMakeFunction.text = @"";
        } else {
            self.foodMakeFunction.text = cookbook.desc;
        }
        
        self.cookerName.text = cookbook.creator.userName;
        
        self.timeLabel.text = cookbook.modifiedTime;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Show Image Error...");
    }
    @finally {
        
    }
    
    
    
    
}

- (void)resetCell
{
    self.chickGoodBtn.selected = NO;
    self.avater.imageView.image = [UIImage imageNamed:@"default_avatar"];
}

-(void)setHadVideo:(BOOL)hadVideo{
    _hadVideo = hadVideo;
    self.vedioBtn.hidden = hadVideo;
}
- (IBAction)Like:(UIButton *)sender {
    [self.delegate ChickLikeBtn:self andBtn:sender];
}

- (IBAction)Play:(UIButton *)sender {
    [self.delegate ChickPlayBtn:self];
}
@end
