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

@property (nonatomic)AutoSizeLabelViewStyle style;

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
    float leftpadding = 0;
    int line = 0;
    int count = 0;
    for (int i = 0; i<tags.count; i++) {
        
        float wide  =  [AutoSizeLabelView boolLabelLength:tags[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:14]}]+20;
        if (leftpadding+wide+PADDING_WIDE+PADDING_WIDE*count>PageW-60) {
            leftpadding=0;
            ++line;
            count = 0;
        }
        UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
        title.frame = CGRectMake(PADDING_WIDE*count+leftpadding,(PADDING_HIGHT+LABEL_H)*line , wide, LABEL_H);

        [title setTitle:tags[i] forState:UIControlStateNormal];
        [title setTitle:tags[i] forState:UIControlStateSelected];
        [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [title setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        title.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        title.titleLabel.textAlignment = NSTextAlignmentCenter;
        title.tag = i;
        title.selected = NO;
        [title addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        title.layer.masksToBounds = YES;
        leftpadding +=wide;
        count++;
        
        if (self.style == AutoSizeLabelViewStyleCreatMenu) {
            
            [title setBackgroundImage:[MyTool createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            [title setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor] forState:UIControlStateSelected];
            title.layer.cornerRadius  = 5;
            

        } else if (self.style == AutoSizeLabelViewStyleMenuDetail) {
            title.layer.cornerRadius  = 15;
            [title setBackgroundImage:[MyTool createImageWithColor:[UIColor purpleColor]] forState:UIControlStateNormal];
            title.enabled = NO;
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
