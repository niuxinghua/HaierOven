//
//  User.h
//  HaierOven
//
//  Created by 刘康 on 14/12/22.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//"data":{"userBaseID":25,"userID":null,"userType":1,"loginName":"cjsyclt","passWord":null,"email":"cjsyclt@163.com","mobile":"13621640580","accType":0,"status":1,"isDeleted":false,"userProfile":{"id":18,"userBaseID":null,"nickName":"cjsyclt","userName":"litao","sex":null,"birthday":null,"accessToken":null,"note":null,"maritalStatus":null,"occupation":null,"monthlyIncome":null,"userAvatar":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg","focusCount":null,"followCount":null,"points":null},"userAttribute":null,"marvellouschefInfo":null}

@property (copy, nonatomic) NSString* userBaseId;

@property (copy, nonatomic) NSString* userId;

@property (copy, nonatomic) NSString* userType;

@property (copy, nonatomic) NSString* loginName;

@property (copy, nonatomic) NSString* password;

@property (copy, nonatomic) NSString* email;

@property (copy, nonatomic) NSString* phone;

@property (copy, nonatomic) NSString* accType;

@property (copy, nonatomic) NSString* status;

@property (nonatomic) BOOL isDeleted;



#pragma mark - userProfile

@property (copy, nonatomic) NSString* userProfileId;

@property (copy, nonatomic) NSString* nickName;

@property (copy, nonatomic) NSString* userName;

@property (copy, nonatomic) NSString* sex;

@property (copy, nonatomic) NSString* birthday;

@property (copy, nonatomic) NSString* accessToken;

@property (copy, nonatomic) NSString* note;

/**
 *  婚姻状态
 */
@property (copy, nonatomic) NSString* maritalStatus;

/**
 *  职业
 */
@property (copy, nonatomic) NSString* occupation;

/**
 *  月薪
 */
@property (copy, nonatomic) NSString* monthlyIncome;

/**
 *  头像
 */
@property (copy, nonatomic) NSString* userAvatar;

/**
 *  粉丝数量
 */
@property (copy, nonatomic) NSString* focusCount;

/**
 *  关注数量
 */
@property (copy, nonatomic) NSString* followCount;


@property (copy, nonatomic) NSString* points;



@property (copy, nonatomic) NSString* userAttribute;

@property (copy, nonatomic) NSString* marvellouschefInfo;



@end
















