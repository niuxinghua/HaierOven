//
//  StudyDetailController.h
//  HaierOven
//
//  Created by dongl on 15/1/20.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, StudyType) {
    StudyTypeTools      = 0,
    StudyTypeMaterial   = 1,
    StudyTypeSkill      = 2,
    
};
@interface StudyDetailController : UITableViewController

@property (nonatomic) StudyType studyType;
@property (nonatomic) NSInteger toolIndex;
@end
