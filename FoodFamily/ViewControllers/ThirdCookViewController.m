//
//  ThirdCookViewController.m
//  FoodFamily
//
//  Created by qianfeng on 16/1/22.
//  Copyright © 2016年 杜卫国. All rights reserved.
//

#import "ThirdCookViewController.h"
#import "ThirdCookBaseModel.h"
#import "ThirdCookModel.h"
#import "ThirdCookFoodView.h"
#import "ThirdCookTableViewCell1.h"
#import "ThirdCookTableViewCell2.h"
#import "ThirdCookTableViewCell3.h"
#import "ThirdCookTableViewCell4.h"

@interface ThirdCookViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSArray            * dataSouce;
@property (nonatomic) ThirdCookBaseModel * cookBaseModel;
@property (nonatomic) ThirdCookModel     * cookModel;
@property (nonatomic) ThirdCookFoodView  * topView;
@property (nonatomic) UIView             * foodView;
@property (nonatomic) UITableView        * tableView;
@property (nonatomic) NSArray            * titleArr;
@end

@implementation ThirdCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"食物简介",@"所需材料",@"具体做法",@"后记"];
    self.title = _thirdPageModelONE.title;
    [self requestData];
    [self crateFoodView];
    [self creatTableView];
    
    [self.view addSubview:self.tableView];
}

- (void)crateFoodView{
    _foodView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    //_foodImageView.backgroundColor = [UIColor grayColor];
   // _foodImageView.image = [UIImage imageNamed:@"111.png"];
    //[self.view addSubview:_foodView];
    //_foodView = [[ThirdCookFoodView alloc]init];
    UINib *nib = [UINib nibWithNibName:@"ThirdCookFoodView" bundle:nil];
    _topView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3 );
   
    [_foodView addSubview:self.topView];
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.tableHeaderView = _foodView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除垂直的滚动条的指示
    _tableView.showsVerticalScrollIndicator = NO;
    //取消tableView自带的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 44;

    
    UINib *nib1 = [UINib nibWithNibName:@"ThirdCookTableViewCell1" bundle:nil];
    [_tableView registerNib:nib1 forCellReuseIdentifier:@"cellID1"];
    
    UINib *nib2 = [UINib nibWithNibName:@"ThirdCookTableViewCell2" bundle:nil];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"cellID2"];
    
    UINib *nib3 = [UINib nibWithNibName:@"ThirdCookTableViewCell3" bundle:nil];
    [_tableView registerNib:nib3 forCellReuseIdentifier:@"cellID3"];
    
    UINib *nib4 = [UINib nibWithNibName:@"ThirdCookTableViewCell4" bundle:nil];
    [_tableView registerNib:nib4 forCellReuseIdentifier:@"cellID4"];

    
    
    [self.view addSubview:_tableView];
}

- (void)requestData{
    [[NetDataEngine sharedInstance]requestThirdPageDataWithId:_thirdPageModelONE.id withSuccess:^(id responsData) {
        _dataSouce = [ThirdCookBaseModel parseRespondsData:responsData];
        _cookBaseModel = _dataSouce[0];
        for (_cookModel in _cookBaseModel.steps) {
            NSLog(@"%@",_cookModel.note);
        }
        [self addData];
        [_tableView reloadData];
    } withFaileBlock:^(NSError *error) {
        
    }];
}

- (void)addData{
    
    [_topView.imageView sd_setImageWithURL:[NSURL URLWithString:_cookBaseModel.cover] placeholderImage:[UIImage imageNamed:@"111.png"]];
    _topView.lable1.text = _cookBaseModel.basefood;
    _topView.lable2.text = _cookBaseModel.during;
    _topView.lable3.text = _cookBaseModel.cuisine;
    _topView.lable4.text = _cookBaseModel.technics;
    _topView.lable5.text = _cookBaseModel.title;

}

#pragma mark <tableView带理方法>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return _cookBaseModel.steps.count;
    }
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 200;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        cell.cell1Lable.text = _cookBaseModel.message;
        return cell;
    }else if (indexPath.section == 1){
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        cell.cell1Lable.text = _cookBaseModel.mainingredient;
        return cell;
    
    }else if (indexPath.section == 2){
        ThirdCookTableViewCell3 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID3" forIndexPath:indexPath];
        _cookModel = _cookBaseModel.steps[indexPath.row];
        [cell.cell3ImageView sd_setImageWithURL:[NSURL URLWithString:_cookModel.pic] placeholderImage:[UIImage imageNamed:@"111.png"]];
        cell.cell3Lable.text = _cookModel.note;
        return cell;
    }else{
        ThirdCookTableViewCell4 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID4" forIndexPath:indexPath];
        return cell;
    
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    if(section == 0){
        
        lable.text = @"食物简介";
        [view addSubview:lable];
        view.backgroundColor = [UIColor grayColor];
    }else if (section == 1){
        lable.text = @"所需食材";
        [view addSubview:lable];
        view.backgroundColor = [UIColor blueColor];

    }else if (section == 2){
        lable.text = @"具体做法";
        [view addSubview:lable];
        view.backgroundColor = [UIColor purpleColor];
    }else if (section == 3){
        lable.text = @"后记";
        [view addSubview:lable];
        view.backgroundColor = [UIColor blackColor];
    }
    
    return view;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return _titleArr[section];
//}
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
