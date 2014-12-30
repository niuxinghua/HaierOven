//
//  CommentViewController.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "CommentListCell.h"

@interface CommentViewController ()

@property (strong, nonatomic) NSMutableArray* comments;
@property (weak, nonatomic) id controller;


@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithData:(NSMutableArray *)comments andController:(id)controller
{
    if (self = [super init]) {
        self.comments = comments;
        self.controller = controller;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 0;
    Comment* comment = self.comments[indexPath.row];
    height += [comment getHeight];
    //    for (Comment* subComment in comment.subComments) {
    //        height += [subComment getHeight];
    //    }
    NSLog(@"indexPath.row：%d, Height:%.2f", indexPath.row, height);
    return height;
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Comment list cell"];
    
    cell.delegete = self.controller;
    
    cell.comment = self.comments[indexPath.row];
    
    return cell;
    
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
