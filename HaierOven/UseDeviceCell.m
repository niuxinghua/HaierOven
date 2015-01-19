//
//  UseDeviceCell.m
//  HaierOven
//
//  Created by dongl on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "UseDeviceCell.h"
@interface UseDeviceCell();
@property (weak, nonatomic) IBOutlet UIView *useBakeFiexView;
@property (strong, nonatomic) UseBakeView* ovenConfigView;
@end
@implementation UseDeviceCell

- (void)awakeFromNib {
    // Initialization code
//    [self initFiexView];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self initFiexView];

//    self.ovenConfigView.delegate = self.delegate;
}


-(void)initFiexView{
    
//    self.ovenConfigView = bakeview;
//    bakeview.delegate = self.delegate;
    if (self.ovenConfigView.delegate == nil) {
        self.ovenConfigView = [[UseBakeView alloc]initWithFrame:CGRectMake(0, 0, self.useBakeFiexView.width, self.useBakeFiexView.height)];
        self.ovenConfigView.delegate = self.delegate;
        [self.useBakeFiexView addSubview:self.ovenConfigView];
    }
    

    
}
@end
