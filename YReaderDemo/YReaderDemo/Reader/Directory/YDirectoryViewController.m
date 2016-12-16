//
//  YDirectoryViewController.m
//  YReaderDemo
//
//  Created by yanxuewen on 2016/12/16.
//  Copyright © 2016年 yxw. All rights reserved.
//

#import "YDirectoryViewController.h"
#import "YDirectoryViewCell.h"
#import "YChapterContentModel.h"

@interface YDirectoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL firstDisplay;
@property (assign, nonatomic) CGFloat beginOffsetY;

@end

@implementation YDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstDisplay = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YDirectoryViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YDirectoryViewCell class])];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    self.beginOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    [self showGoToBtn];
    if (scrollView.contentOffset.y > self.beginOffsetY) {
        [self.goBtn setTitle:@"到底部" forState:UIControlStateNormal];
        self.goBtn.tag = 100;
    } else {
        [self.goBtn setTitle:@"到顶部" forState:UIControlStateNormal];
        self.goBtn.tag = 101;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSLog(@"%s",__func__);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    [self hideGoToBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chaptersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDirectoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDirectoryViewCell class]) forIndexPath:indexPath];
    NSUInteger count = _chaptersArr.count - indexPath.row - 1;
    YChapterContentModel *chapterM = _chaptersArr[count];
    if (count == _readingChapter) {
        cell.imageV.image = [UIImage imageNamed:@"bookDirectory_selected"];
    } else if (chapterM.isLoadCache) {
        cell.imageV.image = [UIImage imageNamed:@"directory_previewed"];
    } else {
        cell.imageV.image = [UIImage imageNamed:@"directory_not_previewed"];
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%zi.",count+1];
    cell.titleLabel.text = chapterM.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0 && _firstDisplay) {
        _firstDisplay = NO;
        CGFloat offsetY = (_chaptersArr.count - 1 - _readingChapter) * 44 - tableView.height/2;
        if (offsetY > _chaptersArr.count * 44 - tableView.height) {
            offsetY = _chaptersArr.count * 44 - tableView.height;
        }
        tableView.contentOffset = CGPointMake(0,offsetY);
    }
}

- (IBAction)tapAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToAction:(id)sender {
    if ([self.goBtn.currentTitle isEqualToString:@"到顶部"]) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [_tableView setContentOffset:CGPointMake(0, (_chaptersArr.count - 1) * 44 - _tableView.height) animated:YES];
    }
}

- (void)showGoToBtn {
    if (self.goBtn.alpha >= 0.9) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.goBtn.alpha = 1;
    }];
}

- (void)hideGoToBtn {
    if (self.goBtn.alpha < 0.1) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.goBtn.alpha = 0;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBtn:(id)sender {
}
@end