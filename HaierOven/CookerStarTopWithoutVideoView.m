//
//  CookerStarTopWithoutVideoView.m
//  HaierOven
//
//  Created by 刘康 on 15/3/1.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookerStarTopWithoutVideoView.h"


@interface CookerStarTopWithoutVideoView () <AutoSizeLabelViewDelegate,CookStarPullViewDelegate>
{
    CGFloat tempHeight;
}

/**
 *  某人的菜谱“Daniel Boulud 的菜谱”
 */
@property (strong, nonatomic) IBOutlet UILabel *cookBookLabel;

@property (weak, nonatomic) IBOutlet UIButton *leaveMsgButton;


@property NSInteger top;
@property NSInteger bottom;
@end

@implementation CookerStarTopWithoutVideoView

-(instancetype)initWithFrame:(CGRect)frame{
    //    if (self = [ super initWithFrame:frame]) {
    self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CookerStarTopWithoutVideoView class]) owner:self options:nil] firstObject];
    self.frame = frame;
    self.avaterImage.layer.cornerRadius = self.avaterImage.height/2;
    self.avaterImage.layer.masksToBounds = YES;
    self.tagsView.delegate = self;
    self.studyCook.layer.masksToBounds = YES;
    self.studyCook.layer.cornerRadius = 15;
    [self initSubviews];
    
    //self.top     = self.vedioImage.bottom+180+56;
    self.bottom  = self.bottomView.top;
    
    self.followButton.layer.cornerRadius = self.followButton.height/2;
    self.followButton.layer.masksToBounds = YES;
    self.leaveMsgButton.layer.cornerRadius = self.leaveMsgButton.height / 2;
    self.leaveMsgButton.layer.masksToBounds = YES;
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}


-(void)initSubviews{
    self.backDownView = [UIView new];
    //    self.backDownView.clipsToBounds = YES;
    self.backDownView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.bottomView = [[CookStarPullView alloc]init];
    self.bottomView.backgroundColor = [UIColor clearColor];
    
    self.tagsView = [[AutoSizeLabelView alloc]init];
    
    self.bottomView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer* swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMoreTags)];
    swipGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.bottomView addGestureRecognizer:swipGesture];
    
    self.bottomView.delegate = self;
    self.cookBookLabel = [UILabel new];
    self.cookBookLabel.textColor = GlobalOrangeColor;
    self.cookBookLabel.font = [UIFont fontWithName:GlobalTitleFontName size:16];
    self.cookBookLabel.textAlignment = NSTextAlignmentCenter;
    
    
}




#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high



-(void)setTags:(NSArray *)tags{
    _tags = tags;
    
    
    //    self.backDownView.frame = CGRectMake(0, self.studyCook.bottom+8, PageW, self.tagsView.lineCount*(PADDING_HIGHT+PADDING_HIGHT)+PADDING_HIGHT+30+28);
    
    self.backDownView.frame = CGRectMake(0, self.studyCook.bottom+8, PageW,1*(PADDING_HIGHT+LABEL_H)+PADDING_HIGHT+30+28);
    //   self.backDownView.frame = CGRectMake(0, self.studyCook.bottom+8, PageW,1*(PADDING_HIGHT+LABEL_H)+PADDING_HIGHT+30 + 20);
    
    self.cookBookLabel.frame = CGRectMake(0, 8, self.backDownView.width, 20);
    
    
    self.tagsView.Frame = CGRectMake(8, self.cookBookLabel.bottom+8, self.width - 16, self.tagsView.lineCount*(PADDING_HIGHT+PADDING_HIGHT));
    self.tagsView.clipsToBounds = YES;
    self.tagsView.delegate = self;
    self.tagsView.style = AutoSizeLabelViewStyleCookStarDetail;
    self.tagsView.tags = tags;
    
    self.bottomView.frame = CGRectMake(0, self.backDownView.height-26, self.backDownView.width, 56);
    
    
    [self addSubview:self.backDownView];
    [self.backDownView addSubview:self.cookBookLabel];
    [self.backDownView addSubview:self.tagsView];
    [self.backDownView addSubview:self.bottomView];
    
    if (self.tagsView.lineCount < 2) {
        self.bottomView.hidden = YES;
        self.clipsToBounds = YES;
        //        CGRect rect = self.bottomView.frame;
        //        rect.size.height = 0;
        //        self.bottomView.frame = rect;
    } else {
        self.bottomView.hidden = NO;
        self.clipsToBounds = NO;
    }
    
}

- (void)setCookerStar:(CookerStar *)cookerStar
{
    _cookerStar = cookerStar;
    [self.avaterImage setImageWithURL:[NSURL URLWithString:cookerStar.avatar] placeholderImage:IMAGENAMED(@"default_avatar.png")];
    
    switch (cookerStar.userLevel) {
        case 1:
            self.levelImageView.image = IMAGENAMED(@"Vcs.png");
            //[self.leaveMsgButton setTitle:@"留言" forState:UIControlStateNormal];
            [self.leaveMsgButton setTitle:@"给厨神留言" forState:UIControlStateNormal];
            break;
        case 2:
            self.levelImageView.image = IMAGENAMED(@"Vcs.png");
            [self.leaveMsgButton setTitle:@"给厨神留言" forState:UIControlStateNormal];
            break;
        case 3:
            self.levelImageView.image = IMAGENAMED(@"Vcs.png");
            break;
            
        default:
            self.levelImageView.image = IMAGENAMED(@"Vcs.png");
            break;
    }
    self.nameLabel.text = cookerStar.userName;
    self.signatureLabel.text = cookerStar.signature;
    //self.followButton.selected = cookerStar.isFollowed;
    
    // 当从首页跳转到厨神详情时获取不到是否关注此厨神，需要重新获取
    [[InternetManager sharedManager] currentUser:CurrentUserBaseId followedUser:cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        
        if (success) {
            NSInteger status = [obj[@"data"] integerValue];
            if (status == 1) {
                self.followButton.selected = YES;
            } else {
                self.followButton.selected = NO;
            }
            
            
        } else {
            self.followButton.selected = NO;
        }
        
    }];
    
    self.descriptionLabel.text = cookerStar.introduction;
    self.cookBookLabel.text = [NSString stringWithFormat:@"%@ 的菜谱", cookerStar.userName];
    
}

-(void)chooseTags:(UIButton *)btn
{
    [self.delegate chickTags:btn];
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

- (IBAction)studyCook:(id)sender {
    [self.delegate studyCook];
}


-(void)showMoreTags{
    //    self.backDownView.frame = CGRectMake(0, self.studyCook.bottom+8, PageW, self.tagsView.lineCount*(PADDING_HIGHT+LABEL_H)+PADDING_HIGHT+30+28);
    //
    //    self.tagsView.Frame = CGRectMake(15, self.cookBookLabel.bottom+8, self.width-30, self.tagsView.lineCount*(LABEL_H+PADDING_HIGHT));
    //
    //    self.bottomView.frame = CGRectMake(0, self.backDownView.height-26, self.backDownView.width, 56);
    
    //[self.delegate UpLoadHeadViewHeight:self.studyCook.bottom+self.bottomView.height];
    [self.delegate updateHeadViewHeight:self.studyCook.bottom + self.bottomView.height];
}

@end
