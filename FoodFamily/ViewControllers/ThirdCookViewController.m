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
#import "CollectFavoriteModel3.h"
#import "CollectFavoriteModel2.h"

@interface ThirdCookViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSArray            * dataSouce;
@property (nonatomic) ThirdCookBaseModel * cookBaseModel;
@property (nonatomic) ThirdCookModel     * cookModel;
@property (nonatomic) ThirdCookFoodView  * topView;
@property (nonatomic) UITableView        * tableView;
@property (nonatomic) NSArray            * titleArr;
@end

@implementation ThirdCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"食物简介",@"所需材料",@"具体做法",@"后记"];
    self.title = _thirdPageModelONE.title;
    [self createNavigationBar];
    [self requestData];
    [self crateFoodView];
    [self creatTableView];

    [self.view addSubview:self.tableView];
 
}
- (void)createNavigationBar{
    
//    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    NSArray *titleArray = @[@"收藏",@"分享"];
    
    for (int index = 0; index < titleArray.count;index++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,50, 40)];
        NSString *title = [titleArray objectAtIndex:index];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        // button.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        button.tag = 5000 + index;
        [button addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
    }
    NSMutableArray *barButtonItemArray = [NSMutableArray array];
    for (UIView *view in buttonArray) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        [barButtonItemArray addObject:barItem];
    }
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
}
- (void)navButtonAction:(UIButton*)button
{
    NSInteger tag = button.tag - 5000;
    switch (tag) {
        case 0:
            [self collectFavoriteFood];
            break;
        case 1:
            [self shareSns];
            break;
        default:
            break;
    }
}
//收藏
- (void)collectFavoriteFood{
    CollectFavoriteModel3 *CFModel3;
    // NSLog(@"%@",_firstPageModel.imagePathThumbnails);
    ThirdCookBaseModel *model = _cookBaseModel;
    NSArray *array = [CollectFavoriteModel3 MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"id=%@",model.id]];
    if(array.count > 0){
        //提示已经收藏过
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经被收藏" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
        NSLog(@"%@",NSHomeDirectory());
        return;
    }else{
        //先判断是否已经收藏过，如果有收藏给出提示，否则保存到数据库中
        //根据vegetable_id 查找数据库中是否已经包含了该记录
        CFModel3 = [CollectFavoriteModel3 MR_createEntity];
        [CFModel3 setUpWithModel3:model];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }

    [self collectFavoriteFood2];
}

- (void)collectFavoriteFood2{
    
    // NSLog(@"%@",_firstPageModel.imagePathThumbnails);
    ThirdCookBaseModel *baseModel = _cookBaseModel;
    for (ThirdCookModel *model in baseModel.steps) {
       CollectFavoriteModel2 *CFModel2;

        //先判断是否已经收藏过，如果有收藏给出提示，否则保存到数据库中
        //根据vegetable_id 查找数据库中是否已经包含了该记录
        CFModel2 = [CollectFavoriteModel2 MR_createEntity];
        [CFModel2 setUpWithModel2:model];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        UIAlertController *contoller = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
        [contoller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:contoller animated:YES completion:nil];
    }
    
}
//分享
- (void)shareSns{


}


- (void)crateFoodView{
    
    UINib *nib = [UINib nibWithNibName:@"ThirdCookFoodView" bundle:nil];
    _topView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3 );
    _topView.layer.cornerRadius = 20;
    _topView.layer.masksToBounds = YES;
   
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT -49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _topView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除垂直的滚动条的指示
    _tableView.showsVerticalScrollIndicator = NO;
    //取消tableView自带的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 20;

    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    if (indexPath.section == 1) {
        return 80;
    }
    if (indexPath.section == 3) {
        return 200;
    }
    return 115;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        if(!_cookBaseModel.message.length){
            cell.cell1Lable.text = _cookBaseModel.message;
        }else{
            cell.cell1Lable.text = @"暂无";
        }
        
        return cell;
    }else if (indexPath.section == 1){
        ThirdCookTableViewCell1 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID1" forIndexPath:indexPath];
        cell.cell1Lable.text = _cookBaseModel.mainingredient;
        return cell;
    
    }else if (indexPath.section == 2){
        ThirdCookTableViewCell3 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID3" forIndexPath:indexPath];
        _cookModel = _cookBaseModel.steps[indexPath.row];
        
       [cell.cell3ImageView sd_setImageWithURL:[NSURL URLWithString:_cookModel.pic] placeholderImage:[UIImage imageNamed:@"111.png"]];
        cell.cell3ImageView.layer.cornerRadius = 12;
        cell.cell3ImageView.layer.masksToBounds = YES;
        cell.cell3Lable.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row + 1,_cookModel.note];
        
        return cell;
    }else if (indexPath.section == 3){
        ThirdCookTableViewCell4 *cell = [_tableView dequeueReusableCellWithIdentifier:@"cellID4" forIndexPath:indexPath];
        NSLog(@"%@",_cookBaseModel.tips );
        if (_cookBaseModel.tips.length) {
            [cell.cell4WebView loadHTMLString:_cookBaseModel.tips baseURL:nil];
        }else{
        
            [cell.cell4WebView loadHTMLString:@"尽情的享受下自己亲手做的美食吧" baseURL:nil];
        
        }
        
        return cell;
    
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 30)];
    lable.layer.cornerRadius = 15;
    lable.layer.masksToBounds = YES;
    lable.backgroundColor = [UIColor grayColor];
    if(section == 0){
        
        lable.text = @"   食物简介";
        [view addSubview:lable];
       
    }else if (section == 1){
        lable.text = @"   所需食材";
        [view addSubview:lable];

    }else if (section == 2){
        lable.text = @"   具体做法";
        [view addSubview:lable];
    }else if (section == 3){
        lable.text = @"   后记";
        [view addSubview:lable];
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
