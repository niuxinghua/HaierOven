//
//  StudyDetailFiexView.h
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyDetailFiexView;
@protocol StudyDetailFiexViewDelegate <NSObject>

-(void)reloadViewWithToolsIndex:(NSInteger)index;

@end
@interface StudyDetailFiexView : UIView
@property (strong, nonatomic) NSArray *tools;
@property (weak, nonatomic) id<StudyDetailFiexViewDelegate>delegate;
@end
