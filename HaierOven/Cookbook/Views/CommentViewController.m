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
#import "CommentCountCell.h"

@interface CommentViewController () <UIScrollViewDelegate>
{
    CGFloat _lastContentOffsetY;
}

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
    return self.comments.count + 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    } else {
        
        CGFloat height = 0;
        Comment* comment = self.comments[indexPath.row - 1];
        height += [comment getHeight];
        //    for (Comment* subComment in comment.subComments) {
        //        height += [subComment getHeight];
        //    }
        NSLog(@"indexPath.row：%d, Height:%.2f", indexPath.row, height);
        return height;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        CommentCountCell* countCell = [tableView dequeueReusableCellWithIdentifier:@"Comment count cell" forIndexPath:indexPath];
        countCell.commentCount = self.comments.count;
        return countCell;
    } else {
        
        CommentListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Comment list cell"];
        
        cell.delegete = self.controller;
        
        cell.comment = self.comments[indexPath.row - 1];
        
        return cell;
    }
    
    
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _lastContentOffsetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
  
    if (scrollView.contentOffset.y <= 0) {
        scrollView.scrollEnabled = NO;
    } else {
        scrollView.scrollEnabled = YES;
    }
    
        if (scrollView.contentOffset.y < _lastContentOffsetY)
        {
            //        NSLog(@"向下拉动");
            
            
        } else if (scrollView.contentOffset.y > _lastContentOffsetY)
        {
            
            //        NSLog(@"向上拉动");
            
            
        }
    
    
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
