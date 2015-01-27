//
//  StudyCookTools.m
//  HaierOven
//
//  Created by dongl on 15/1/27.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookTools.h"

@implementation StudyCookTools
-(CGFloat)getHeight{
    CGFloat height = self.images.count *(PageW-38)*self.imageRect+8*self.images.count;
    
    height += [MyUtils getTextSizeWithText:self.name andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTitleFontName size:14]} andTextWidth:PageW-38].height;
    height += [MyUtils getTextSizeWithText:self.description andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTextFontName size:14]} andTextWidth:PageW-38].height;
    return height+31;
}
@end
