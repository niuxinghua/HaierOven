//
//  CookStarDetailController.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarDetailController.h"
#import "CookStarDetailTopView.h"
#import "MainViewNormalCell.h"
#import "AutoSizeLabelView.h"
#import "ChatViewController.h"
#import "MJRefresh.h"
#import "CookbookDetailControllerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "StudyCookViewController.h"

#import "MainSearchViewController.h"
#import "UpLoadingMneuController.h"

@interface CookStarDetailController ()<CookStarDetailTopViewDelegate>
{
    CGSize movesize;
    CGFloat topViewHight;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) CookStarDetailTopView *cookStarDetailTopView;
@property (strong, nonatomic) NSString *decString;

@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) UIButton *tempBtn;

@property (strong, nonatomic) NSMutableArray* cookbooks;

@property (nonatomic) NSInteger pageIndex;

@property (strong, nonatomic) MPMoviePlayerController* player;

@property (strong, nonatomic) NSMutableArray* messages;

@end

@implementation CookStarDetailController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.tags = [NSMutableArray array];
        self.cookbooks = [NSMutableArray array];
        self.pageIndex = 1;
    }
    return self;
}

#pragma mark - 获取聊天记录

- (void)loadMessages
{
    NSString* userBaseId = CurrentUserBaseId;
    self.messages = [NSMutableArray array];
    [[InternetManager sharedManager] getChatMessagesFromUser:userBaseId toUser:self.cookerStar.userBaseId status:-1 pageIndex:1 callBack:^(BOOL success, id obj, NSError *error) {
        
        if (success) {
            NSArray* arr = obj;
            
            [self.messages addObjectsFromArray:arr];

        } else {
            [super showProgressErrorWithLabelText:@"获取失败" afterDelay:1];
        }
        
    }];
    
}

#pragma mark - 其他网络请求

- (void)loadCookerStarTags
{
    [[InternetManager sharedManager] getUserTagsWithUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
        if (success) {
            for (Tag* tag in obj) {
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];
                [self.tags addObject:tag.name];

            }
            self.cookStarDetailTopView.tags = self.tags;
            
            
            
            //topViewHight = [self getHeight];
            CGRect frameOfHeader = self.cookStarDetailTopView.frame;
            frameOfHeader.size.height =[self getHeight];
            self.cookStarDetailTopView.frame = frameOfHeader;
            
//            self.cookStarDetailTopView.frame = CGRectMake(0, 0, Main_Screen_Width, [self getHeight]);
            self.mainTable.tableHeaderView = self.cookStarDetailTopView;
            
            
//            self.mainTable.tableHeaderView.frame = CGRectMake(0, 0, Main_Screen_Width, [self getHeight]);
//            self.mainTable.tableHeaderView.clipsToBounds = YES;
//            self.cookStarDetailTopView.Frame=CGRectMake(0, 0, PageW, topViewHight-36);
//            self.mainTable.tableHeaderView.frame=CGRectMake(0, 0, PageW, topViewHight-36);
//           [self.mainTable reloadData];
        }else {
            [super showProgressErrorWithLabelText:@"获取标签失败" afterDelay:1];
        }
    }];
}

- (void)loadUserCookbooks
{
    [[InternetManager sharedManager] getCookbooksWithUserBaseId:self.cookerStar.userBaseId cookbookStatus:1 pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
        
        if (success) {
            NSArray* arr = obj;
            if (arr.count < PageLimit && _pageIndex != 1) {
                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
            }
            if (_pageIndex == 1) {
                self.cookbooks = obj;
            } else {
                [self.cookbooks addObjectsFromArray:arr];
            }
            
            [self.mainTable reloadData];
        } else {
            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
        }
        
    }];
    
//    [[InternetManager sharedManager] getFriendCookbooksWithUserBaseId:self.cookerStar.userBaseId pageIndex:_pageIndex callBack:^(BOOL success, id obj, NSError *error) {
//        
//        if (success) {
//            NSArray* arr = obj;
//            if (arr.count < PageLimit && _pageIndex != 1) {
//                [super showProgressErrorWithLabelText:@"没有更多了..." afterDelay:1];
//            }
//            if (_pageIndex == 1) {
//                self.cookbooks = obj;
//            } else {
//                [self.cookbooks addObjectsFromArray:arr];
//            }
//            
//            [self.mainTable reloadData];
//        } else {
//            [super showProgressErrorWithLabelText:@"获取菜谱失败" afterDelay:1];
//        }
//        
//        
//    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    self.mainTable.delegate = self;
    self.mainTable.dataSource  = self;
    [self addFooter];
    [self updateUI];
    // Do any additional setup after loading the view.
}

- (void)updateUI
{
    self.cookStarDetailTopView.cookerStar = self.cookerStar;
    [self loadCookerStarTags];
    [self loadUserCookbooks];
//    [self loadMessages];
}

-(void)SetUpSubviews{
    self.decString = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    movesize = [MyUtils getTextSizeWithText:self.decString andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTitleFontName size:11.5]} andTextWidth:PageW-32];
    
    topViewHight = [self getHeight];
    
    self.cookStarDetailTopView = [[CookStarDetailTopView alloc]initWithFrame:CGRectMake(0, 0, PageW, topViewHight-36)];
    
    self.cookStarDetailTopView.delegate = self;
    self.mainTable.tableHeaderView = self.cookStarDetailTopView;
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    self.cookStarDetailTopView.tags =self.tags;
    

}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.mainTable addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        vc.pageIndex = 1;
        [vc loadUserCookbooks];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.mainTable headerEndRefreshing];
            
        });
        
    }];
    
}


- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    
    [self.mainTable addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加根据pageIndex加载数据
        
        vc.pageIndex++;
        [vc loadUserCookbooks];
        
        // 加载数据，0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.mainTable footerEndRefreshing];
            
        });
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cookbooks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =@"MainViewNormalCell";
    MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = GlobalGrayColor;
    cell.AuthorityLabel.hidden = YES;
    cell.cookbook = self.cookbooks[indexPath.row];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*0.8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cookbook* selectedCookbook = self.cookbooks[indexPath.row];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    CookbookDetailControllerViewController* detailController = [storyboard instantiateViewControllerWithIdentifier:@"Cookbook detail controller"];
    detailController.cookbookId = selectedCookbook.ID;
    [self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark-  TopViewDelegate
-(void)ponnedHeadView:(NSInteger)height top:(NSInteger)top AndBottom:(NSInteger)Bottom{
    
    if (height>topViewHight) {
        height=topViewHight;
    }else if (height<445+movesize.height){
        height=445+movesize.height;
    }
    self.cookStarDetailTopView.height = height;
//    self.mainTable.tableHeaderView = self.cookStarDetailTopView;
}


-(void)follow:(UIButton *)sender{
  
    if (!IsLogin) {
        [super openLoginController];
        return;
    }
    if ([self.cookerStar.userBaseId isEqualToString:CurrentUserBaseId]) {
        [super showProgressErrorWithLabelText:@"不能关注自己" afterDelay:1];
        return;
    }
    NSString* userBaseId = CurrentUserBaseId;
    if (sender.selected) {
        // 已关注，取消关注
        [[InternetManager sharedManager] deleteFollowWithUserBaseId:userBaseId andFollowedUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"取消关注成功");
            } else {
                [super showProgressErrorWithLabelText:@"取消失败" afterDelay:1];
            }
        }];
    } else {
        // 未关注，添加关注
        [[InternetManager sharedManager] addFollowWithUserBaseId:userBaseId andFollowedUserBaseId:self.cookerStar.userBaseId callBack:^(BOOL success, id obj, NSError *error) {
            if (success) {
                NSLog(@"关注成功");
            } else {
                [super showProgressErrorWithLabelText:@"关注失败" afterDelay:1];
            }
        }];
    }
    
    sender.selected = !sender.selected;
    
    
}
-(void)leaveMessage{
    
    NSLog(@"留言");
    
    if ([self.cookerStar.userBaseId isEqualToString:CurrentUserBaseId]) {
        [super showProgressErrorWithLabelText:@"不能给自己留言" afterDelay:1];
        return;
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    ChatViewController* chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"Chat view controller"];
    chatViewController.toUserId = self.cookerStar.userBaseId;
//    chatViewController.messages = self.messages;
    chatViewController.toUserName = self.cookerStar.userName;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    
}
-(void)playVideo{
   
#warning 暂用视频
    
//    NSURL* url = [[NSBundle mainBundle] URLForResource:@"product-design-animation-cn-20130712_848x480" withExtension:@"mp4"];
    NSURL* url = [NSURL URLWithString:@"http://cloud.edaysoft.cn/content/iceage4.mp4"];
//    NSURL* url = [NSURL URLWithString:self.cookerStar.videoPath];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
    [self.cookStarDetailTopView addSubview:self.player.view];
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame:) name:MPMoviePlayerWillExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
}

- (void)changeFrame:(NSNotification*)notification
{
    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
}

- (void)close:(NSNotification*)sender
{
    [self.player stop];
    [self.player.view removeFromSuperview];
//    self.player.view.frame = self.cookStarDetailTopView.vedioImage.frame;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:self.player];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)studyCook{
    NSLog(@"新手学烘焙");
    StudyCookViewController* studyController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyCookViewController"];
    [self.navigationController pushViewController:studyController animated:YES];
}

-(void)chickTags:(UIButton*)btn{
    self.tempBtn.selected = NO;
    btn.selected= btn.selected ==YES? NO:YES;
    self.tempBtn = btn;
    
}

#define PADDING_WIDE    15   //标签左右间距
#define PADDING_HIGHT    8   //标签上下间距
#define LABEL_H    20   //标签high


-(float)getHeight{
    
    float height = 0.0;
    
    if (self.cookStarDetailTopView.descriptionLabel.text.length==0) {
        height -= 16;
    }
    
    height += [MyUtils getTextSizeWithText:self.cookerStar.introduction andTextAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:11.5]} andTextWidth:Main_Screen_Width - 32].height;
    
    self.cookStarDetailTopView.tagsView.frame = CGRectMake(15, 20+8+8, Main_Screen_Width - 30, (LABEL_H + PADDING_HIGHT));
    
    height += 188 + 8;
    
    height += (Main_Screen_Width - 70) / 5 * 3;
    
    height += 8 + 31 + 8;
    
    //height += 35;   //额外添加
    
    height += 8  + 20 + 8;   //出身姓名高度
    
    height += LABEL_H + PADDING_HIGHT;
    
    height += 30;   //下拉label
    
    if (self.cookStarDetailTopView.tagsView.lineCount==1) {
        height -= 30;
    }
    return height;
}


-(void)UpLoadHeadViewHeight:(CGFloat)height{
    
    float updateHeight = [self getHeight];
    
//    updateHeight += self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H);
    
    updateHeight += (self.cookStarDetailTopView.tagsView.lineCount - 1) * (PADDING_HIGHT + LABEL_H);

    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frameOfHeader = self.cookStarDetailTopView.frame;
        frameOfHeader.size.height = updateHeight;
        self.cookStarDetailTopView.frame = frameOfHeader;
        
        CGFloat heightOfContainer = self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H) + 30 + 30;
        self.cookStarDetailTopView.backDownView.frame = CGRectMake(0, self.cookStarDetailTopView.studyCook.bottom + 8, Main_Screen_Width,heightOfContainer);
        
        self.cookStarDetailTopView.tagsView.frame = CGRectMake(15, 38, Main_Screen_Width - 30, self.cookStarDetailTopView.tagsView.lineCount * (PADDING_HIGHT + LABEL_H));
        self.cookStarDetailTopView.bottomView.frame = CGRectMake(0, self.cookStarDetailTopView.tagsView.bottom, Main_Screen_Width, 56);
        
        self.cookStarDetailTopView.frame = CGRectMake(0, 0, Main_Screen_Width, updateHeight);
        
        self.mainTable.tableHeaderView = self.cookStarDetailTopView;
    }];
    
    
    
//    [self.cookStarDetailTopView setNeedsLayout];
    
    
    NSLog(@"%f",height);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
