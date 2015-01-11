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

@interface CookStarDetailController ()<CookStarDetailTopViewDelegate>
{
    CGSize movesize;
    CGFloat topViewHight;
}

@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (strong, nonatomic) CookStarDetailTopView *cookStarDetailTopView;
@property (strong, nonatomic) NSString *decString;

@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) UIButton *tempBtn;
@end

@implementation CookStarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpSubviews];
    self.mainTable.delegate = self;
    self.mainTable.dataSource  = self;
    

    // Do any additional setup after loading the view.
}

-(void)SetUpSubviews{
    self.tags = @[@"1",@"2",@"3",@"4泡芙",@"泡芙",@"6泡芙",@"7蛋疼"];
    self.decString = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    movesize = [MyUtils getTextSizeWithText:self.decString andTextAttribute:@{NSFontAttributeName:[UIFont fontWithName:GlobalTitleFontName size:15]} andTextWidth:PageW-32];
    
    topViewHight = [self getHeight];
    
    self.cookStarDetailTopView = [[CookStarDetailTopView alloc]initWithFrame:CGRectMake(0, 0, PageW, topViewHight-36)];
    self.cookStarDetailTopView.delegate = self;
    self.mainTable.tableHeaderView = self.cookStarDetailTopView;
    
    [self.mainTable registerNib:[UINib nibWithNibName:NSStringFromClass([MainViewNormalCell class]) bundle:nil] forCellReuseIdentifier:@"MainViewNormalCell"];
    self.cookStarDetailTopView.tags =self.tags;
    

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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSString *cellIdentifier =@"MainViewNormalCell";
    MainViewNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = GlobalGrayColor;
    cell.AuthorityLabel.hidden = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PageW*0.6;
}



#pragma mark-  TopViewDelegate
-(void)ponnedHeadView:(NSInteger)height top:(NSInteger)top AndBottom:(NSInteger)Bottom{

    
    if (height>topViewHight) {
        height=topViewHight;
    }else if (height<455+movesize.height){
        height=455+movesize.height;
    }
    self.cookStarDetailTopView.height = height;
    self.mainTable.tableHeaderView = self.cookStarDetailTopView;

}

-(void)follow:(UIButton *)sender{
    sender.selected =sender.selected==NO?YES:NO;
}
-(void)leaveMessage{
    NSLog(@"留言");
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Liukang" bundle:nil];
    ChatViewController* chatViewController = [storyboard instantiateViewControllerWithIdentifier:@"Chat view controller"];
    
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    
}
-(void)playVideo{
    NSLog(@"播放");
}
-(void)studyCook{
    NSLog(@"新手学烘焙");
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
    float leftpadding = 0;
    int line = 1;
    int count = 0;
    for (int i = 0; i<self.tags.count; i++) {
        float wide  =  [AutoSizeLabelView boolLabelLength:self.tags[i] andAttribute:@{NSFontAttributeName: [UIFont fontWithName:GlobalTextFontName size:14]}]+20;
        
        if (leftpadding+wide+PADDING_WIDE*count>PageW-90) {
            leftpadding=0;
            ++line;
            count = 0;
        }
        
        leftpadding +=wide;
        count++;
    }

    
    return (PADDING_HIGHT+LABEL_H)*line+455+movesize.height;
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
