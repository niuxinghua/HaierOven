//
//  StudyCookTools.m
//  HaierOven
//
//  Created by dongl on 15/1/27.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "StudyCookTools.h"
#import "StudyCookImages.h"
@implementation StudyCookTools
-(CGFloat)getHeight{
//    CGFloat height = self.images.count *((PageW-38)*self.imageRect+8);
    CGFloat height = 0;

    for (StudyCookImages *images in self.images) {
        height +=(PageW-38)*images.imageRect+8;
    }
    
    height += [MyUtils getTextSizeWithText:self.name andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTitleFontName size:14]} andTextWidth:PageW-38].height;
    

    height += [MyUtils getTextSizeWithText:self.desc andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTextFontName size:14]} andTextWidth:PageW-38].height;
    
    
//        NSLog(@"%@ %f", self.description , [MyUtils getTextSizeWithText:self.description andTextAttribute:@{NSFontAttributeName :[UIFont fontWithName:GlobalTextFontName size:14]} andTextWidth:PageW-38].height);
    
    return height+9+8+8+8;

}
@end
