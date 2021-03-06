//
//  PersonalCenterSectionView.h
//  HaierOven
//
//  Created by dongl on 14/12/19.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SectionType) {
    sectionPersonalCenter   =1,
    sectionFollow           =2,
    sectionBakeHouse        =3,
    sectionNotification     =4,
    sectionRegister         =5,
    sectionHowToUse         =6,
};



@class PersonalCenterSectionView;
@protocol PersonalCenterSectionViewDelegate <NSObject>
@required
-(void)SectionType:(NSInteger)type;

@end
@interface PersonalCenterSectionView : UIView

@property (nonatomic) BOOL isFirstContent;

@property (nonatomic) SectionType sectionType;
@property (strong, nonatomic) IBOutlet UIButton *pushedButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *orangeLine;
@property (strong, nonatomic) IBOutlet UIImageView *middleLine;
@property (weak, nonatomic)id<PersonalCenterSectionViewDelegate>delegate;
@end
