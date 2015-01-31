//
//  AutoSizeLabelView.m
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AutoSizeLabelView.h"
#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high

@interface AutoSizeLabelView ()

@property (strong, nonatomic)UIButton *tempBtn;

@end

@implementation AutoSizeLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.style = AutoSizeLabelViewStyleCreatMenu;
       
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.style = AutoSizeLabelViewStyleCreatMenu;
     
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame style:(AutoSizeLabelViewStyle)style
{
    
    self.style = style;
    
    return self;
}


-(void)setTags:(NSArray *)tags{
    _tags = tags;
    
    self.lineCount = 1;
    
    for (UIButton* button in self.subviews) {
        [button removeFromSuperview];
    }
    
    for (int i = 0; i<tags.count; i++) {
        float wide  =  [AutoSizeLabelView boolLabelLength:tags[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:12]}]+20;
        UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
     
        if (i==0) {
            title.frame = CGRectMake(0, 0, 0, 0);
            self.tempBtn = title;

        }
        if(self.tempBtn.right+wide+PADDING_WIDE > self.width){
            CGRect rect = self.tempBtn.frame;
            rect.origin.y = self.tempBtn.bottom+PADDING_HIGHT;
            self.tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.tempBtn.frame = CGRectMake(0, rect.origin.y, 0, 0);
            self.lineCount ++;
        }


        title.frame = CGRectMake(self.tempBtn.right+PADDING_WIDE, self.tempBtn.top, wide, LABEL_H);
        
        self.tempBtn = title;

        
        [title setTitle:tags[i] forState:UIControlStateNormal];
        [title setTitle:tags[i] forState:UIControlStateSelected];
        [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [title setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        title.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        title.titleLabel.textAlignment = NSTextAlignmentCenter;
        title.tag = i;
        if (self.selectedTags != nil) {
            for (NSString* tagStr in self.selectedTags) {
                if ([[title titleForState:UIControlStateNormal] isEqualToString:tagStr]) {
                    title.selected = YES;
                    break;
                }
            }
        } else {
            title.selected = NO;
        }
        
        
        [title addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        title.layer.masksToBounds = YES;
        
        if (self.style == AutoSizeLabelViewStyleCreatMenu) {
            
            [title setBackgroundImage:[MyTool createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            [title setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forState:UIControlStateSelected];
            title.layer.cornerRadius  = 3;
            

        } else if (self.style == AutoSizeLabelViewStyleMenuDetail) {
            title.layer.cornerRadius  = LABEL_H / 2;
            [title setBackgroundImage:[MyTool createImageWithColor:RGB(161, 101, 111)] forState:UIControlStateNormal];
            //title.enabled = NO;
        }else if (self.style == AutoSizeLabelViewStyleCookStarDetail){
            title.layer.cornerRadius  = 10;
            [title setBackgroundImage:[MyTool createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            [title setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forState:UIControlStateSelected];
        }
        
        [self addSubview:title];
    }
}


-(void)select:(UIButton*)sender{
    
    [self.delegate chooseTags:sender];

}

+(float )boolLabelLength:(NSString *)strString
            andAttribute:(NSDictionary *)attribute{
    
    if ([strString isEqual:[NSNull null]]) {
        return 0;
    }else{
        CGSize label = [strString boundingRectWithSize:CGSizeMake(275,2000) options:NSStringDrawingUsesLineFragmentOrigin attributes: attribute context:nil].size;
        return label.width;
    }
}


@end
