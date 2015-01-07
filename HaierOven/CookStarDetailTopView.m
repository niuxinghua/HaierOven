
//
//  CookStarDetailTopView.m
//  HaierOven
//
//  Created by dongl on 15/1/6.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarDetailTopView.h"
#import "AutoSizeLabelView.h"
@interface CookStarDetailTopView ()<AutoSizeLabelViewDelegate>
{
    CGFloat tempHeight;
}
@property (strong, nonatomic) IBOutlet UIImageView *avaterImage;
@property (strong, nonatomic) IBOutlet UIView *backDownView;//计算用
@property (strong, nonatomic) IBOutlet AutoSizeLabelView *tagsView;
/**
 *  某人的菜谱“Daniel Boulud 的菜谱”
 */
@property (strong, nonatomic) IBOutlet UILabel *cookBookLabel;
/**
 *  底部下拉view
 */
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *chickMoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *studyCook;


@property NSInteger top;
@property NSInteger bottom;
@end
@implementation CookStarDetailTopView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookStarDetailTopView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.avaterImage.layer.cornerRadius = self.avaterImage.height/2;
    self.avaterImage.layer.masksToBounds = YES;
    self.tagsView.delegate = self;
    self.studyCook.layer.masksToBounds = YES;
    self.studyCook.layer.cornerRadius = 15;
    [self initTagsView];

    self.top     = self.vedioImage.bottom+180+56;
    self.bottom  = self.bottomView.top;
    NSLog(@"%ld  %ld" , (long)self.top,(long)self.bottom);

    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}


-(void)initTagsView{
    self.tagsView = [[AutoSizeLabelView alloc]initWithFrame:CGRectMake(15, self.cookBookLabel.bottom+8, self.width-30, self.backDownView.height-57)];
    [self.backDownView addSubview:self.tagsView];
}



-(void)setTags:(NSArray *)tags{
    _tags = tags;
    self.tagsView.style = AutoSizeLabelViewStyleCookStarDetail;
    self.tagsView.tags = tags;
}

-(void)chooseTags:(UIButton *)btn{
    [self.delegate chickTags:btn.tag];
}

- (IBAction)labelSwipped:(UISwipeGestureRecognizer *)sender {
    
    NSLog(@"向下轻扫");
    
    
}
- (IBAction)follow:(UIButton *)sender {
    [self.delegate follow:sender];
}
- (IBAction)leaveMessage:(id)sender {
    [self.delegate leaveMessage];
}
- (IBAction)PlayVedio:(id)sender {
    [self.delegate playVideo];
}
- (IBAction)studyCook:(id)sender {
    [self.delegate studyCook];
}

- (IBAction)labelPanned:(UIPanGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self]; //获取在点的位置
    //区分究竟是哪种状态
    switch ((int)sender.state) {
        case UIGestureRecognizerStateBegan:
            tempHeight = p.y;
            
            break;
        case UIGestureRecognizerStateChanged:
//            imageView.center = p; //拖动图片
//            super.frame =CGRectMake(super.left, p.y, super.width, super.height);
            [self.delegate ponnedHeadView:p.y top:self.top AndBottom:self.bottom];
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
    }
    
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    UITouch * touch = [touches allObjects][0];
//    CGPoint location = [touch locationInView:self];
//    
//    CGRect rect = [self.chickMoreLabel convertRect:self.chickMoreLabel.frame toView:self];
//    
//    if(CGRectContainsPoint(rect, location)){
//        NSLog(@"在里面");
//        UITableView *table =  (UITableView *)self.superview;
//        table.scrollEnabled = NO;
//    }else {
//        NSLog(@"不在");
//        UITableView *table =  (UITableView *)self.superview;
//        table.scrollEnabled = YES;
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITableView *table =  (UITableView *)self.superview;
//    table.scrollEnabled = YES;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
