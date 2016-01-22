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
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID1"];
    
    
    
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
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
