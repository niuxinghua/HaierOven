//
//  StepCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "StepCell.h"

@interface StepCell ()

@property (weak, nonatomic) IBOutlet UILabel *stepIndexLabel;

@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;

@property (weak, nonatomic) IBOutlet UILabel *stepDescLabel;

@end

@implementation StepCell

- (void)awakeFromNib {
    // Initialization code
    self.stepIndexLabel.layer.masksToBounds = YES;
    self.stepIndexLabel.layer.cornerRadius = self.stepIndexLabel.height / 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setStep:(Step *)step
{
    _step = step;
    self.stepIndexLabel.text = step.index;
    self.stepDescLabel.text = step.desc;
    
    //区分是否是全路径
    NSString* imagePath = [step.photo hasPrefix:@"http"] ? step.photo : [BaseOvenUrl stringByAppendingPathComponent:step.photo];
    imagePath = [imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    @try {
        
        [self.stepImageView setImageWithURL:[NSURL URLWithString:imagePath]];
        
//        dispatch_queue_t queue = dispatch_queue_create("downloadImage.queue", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(queue, ^{
//            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
//            //UIImage* image = [UIImage imageWithData:data scale:0.1];
//            UIImage* image = [UIImage imageWithData:data];
//            [CBImageCompressor compressImage:image limitSize:512*1024*8 maxSide:400 completion:^(NSData *data) {
//                UIImage* compressedImage = [UIImage imageWithData:data];
//                self.stepImageView.image = compressedImage;
//            }];
//        });
    
    }
    @catch (NSException *exception) {
        NSLog(@"Show Image Error...");
    }
    @finally {
        
    }
    
}

@end
