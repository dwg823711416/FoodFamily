//
//  ThirdPopViewController.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/21.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "ThirdPopViewController.h"

@interface ThirdPopViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)NSArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThirdPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // _str = @"";
    _array = @[@"家常饭菜",@"女人最爱",@"男人最爱",@"利身止咳",@"养颜美容",@"滋补养生"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //把内容控制器消失
    
    [self willChangeValueForKey:@"str"];
    _str = _array[indexPath.row];
    [self didChangeValueForKey:@"str"];
    //NSLog(@"%@",_str);
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
