//
//  ViewController.m
//  图片操作
//
//  Created by LUOSU on 2019/2/13.
//  Copyright © 2019 LUOSU. All rights reserved.
//

#import "ViewController.h"
#import "ImageTransCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

static  NSString *cellIdentifier = @"myImageCell" ;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ImageTransCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTransCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger imageIndex = indexPath.row % 8 + 1;
    cell.bigImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", imageIndex]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

@end
