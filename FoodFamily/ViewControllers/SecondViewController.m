//
//  SecondViewController.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "SecondViewController.h"
#import "CityNameModel.h"
#import "MyTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SecondViewController2.h"
#import "MyMapSearchTableViewCell.h"
#define CITY_NAME _rightBarButton.titleLabel.text
@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
@property (nonatomic) BOOL                        cityName;
@property (nonatomic) UIView                    * cityView;
@property (nonatomic) NSArray                   * dataSouce;
@property (nonatomic) UITableView               * cityTableView;
@property (nonatomic) UITableView               * searchTableView;
@property (nonatomic) UIView                    * headView;
@property (nonatomic) NSMutableArray            * spreadOutArray;
@property (nonatomic) UIImageView               * imageView;
@property (nonatomic) UIButton                  * rightBarButton;
@property (nonatomic) UIButton                  * leftBarButton;
@property (nonatomic) BOOL                        isSearch;
@property (nonatomic) UIImageView               * baseImageView;
@property (nonatomic) NSString                  * selectCityName;
@property (nonatomic) MAMapView                 * mapView;
@property (nonatomic) AMapSearchAPI             * search;
@property (nonatomic) AMapGeocodeSearchResponse * response;//储存正向地理编码所得到的结果
@property (nonatomic) UISearchController        * searchController;
@property (nonatomic) NSString                  * searchText;
@property (nonatomic) NSMutableArray            * mapPOIArray;//储存周边的POI
@property(nonatomic)  NSMutableArray            * searchResultArray;//搜索结果
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapPOIArray = [NSMutableArray array];
    _searchResultArray = [NSMutableArray array];
    _spreadOutArray = [NSMutableArray array];
    //self.navigationController.navigationBar.translucent = NO;
    self.title = @"各地美味";
    [self createNavigationRightBarButtonItems];
    [self createNavigationLeftBarButtonItems];
    _baseImageView = [[UIImageView alloc]initWithFrame:SCREEN_RECT];
    _baseImageView.image = [UIImage imageNamed:@"个人中心.png"];
    [self.view addSubview:_baseImageView];
    _cityView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 64, 80, 0)];
    _cityView.backgroundColor = [UIColor whiteColor];
    _cityView.alpha = 0.6;
    [self.view addSubview:_cityView];
    
    [self requestData];
    
    for (NSInteger index = 0; index < _dataSouce.count; index ++) {
        [_spreadOutArray addObject:@"0"];
    }
}

- (void)createNavigationRightBarButtonItems{
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarButton.frame = CGRectMake(0, 0, 100, 50);
    [_rightBarButton setTitle:@"选择城市" forState:UIControlStateNormal];
    [_rightBarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_rightBarButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_rightBarButton addTarget:self action:@selector(touchRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *barButtonItemArray = [NSMutableArray array];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBarButton];
    [barButtonItemArray addObject:barItem];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
}

- (void)createNavigationLeftBarButtonItems{
    _leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBarButton.frame = CGRectMake(0, 0, 100, 50);
    [_leftBarButton setTitle:@"搜索" forState:UIControlStateNormal];
    [_leftBarButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leftBarButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_leftBarButton addTarget:self action:@selector(touchLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    NSMutableArray *leftBarButtonItemArray = [NSMutableArray array];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:_leftBarButton];
    [leftBarButtonItemArray addObject:leftBarItem];
    self.navigationItem.leftBarButtonItems = leftBarButtonItemArray;
}

- (void)touchRightBarButton{
    
    if (!_cityName) {
        [_cityView addSubview:self.tableview];
        NSLog(@"拉伸了");
        [UIView animateWithDuration:0.5 animations:^{
            _cityTableView.frame = CGRectMake(0, 0, 80, [UIScreen mainScreen].bounds.size.height-64-49);
            _cityView.frame = CGRectMake(SCREEN_WIDTH - 100, 64, 80, SCREEN_HEIGHT - 64 -49);
        } completion:^(BOOL finished) {
            _cityName = YES;
            [_cityView addSubview:self.tableview];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            //[_cityTableView removeFromSuperview];
            _cityTableView.frame = CGRectMake(0, 0, 80, 0);
            _cityView.frame = CGRectMake(SCREEN_WIDTH - 100, 64, 80, 0);
            NSLog(@"收缩了");
        } completion:^(BOOL finished) {
            _cityName = NO;
        }];
    }
}

- (void)touchLeftBarButton{
    if (!_isSearch) {
        [self createSearchController];
        _cityView.alpha = 0;
        _isSearch = YES;
    }else{
        [self removeSearchController];
        _cityView.alpha = 0.6;
        _isSearch = NO;
    }
}
//创建searchController
- (void)createSearchController{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //指定代理：当搜索的内容发生变化，会调用相应的代理方法
    self.searchController.searchResultsUpdater = self;
    //指定代理：当搜索框显示，消失等事件发生时调用相应的代理方法
    self.searchController.delegate = self;
    //把UISearchBar添加到tableView的headView上
    //首先需要调整searBar的大小
    [self.searchController.searchBar sizeToFit];
    //在searController弹出期间是否把背景取消掉
    //如果需要选中搜索的结果，必须把背景取消
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //当搜索框弹出时是否允许覆盖当前的viewcontroller
    //如果definesPresentationContext 设置为YES，就会在当前的viewController上弹出
    //注意：当导航控制器为不透明时，务必设置此属性
    self.definesPresentationContext = NO;
    
    //首先让搜索结果赋值为数据源
    self.searchResultArray = self.mapPOIArray;
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.alpha = 0.8;
    _searchTableView.tableHeaderView = self.searchController.searchBar;
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    _searchTableView.estimatedRowHeight = 10;
    UINib * nib = [UINib nibWithNibName:@"MyMapSearchTableViewCell" bundle:nil];
    [_searchTableView registerNib:nib forCellReuseIdentifier:@"searchCellId"];
    
    [self.view addSubview:_searchTableView];

}

- (void)removeSearchController{
    [_searchTableView removeFromSuperview];
    
}
- (void)requestData{
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"城市代码" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    _dataSouce =[CityNameModel analysisData:data];
    
}
- (UITableView *)tableview {
    
    if (_cityTableView == nil) {
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, 0)];
        _cityTableView.dataSource = self;
        _cityTableView.delegate = self;
        _cityTableView.estimatedRowHeight = 10;
        _cityTableView.backgroundColor = [UIColor clearColor];
        UINib *nib =[UINib nibWithNibName:@"MyTableViewCell" bundle:nil];
        [_cityTableView registerNib:nib forCellReuseIdentifier:@"cellID"];
        
        
    }
    return _cityTableView;
}
#pragma mark
#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_isSearch) {
        if ([_spreadOutArray[section] isEqualToString:@"0"]) {
            return 0;
        }
        CityNameModel *model = _dataSouce[section];
       // NSLog(@"%ld",model.市.count);
        return model.市.count;
    }else{
    
        return _searchResultArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!_isSearch) {
        return 25;
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isSearch) {
        MyTableViewCell *cell = [_cityTableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        CityNameModel *model = _dataSouce[indexPath.section];
        NSArray *arr = model.市;
        NSDictionary *dic = arr[indexPath.row];
        cell.cellLable.text = dic[@"市名"];
        
        return cell;

    }else{
        
//        for (AMapPOI *poi in _mapPOIArray) {
//            strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, poi.description];
//            //NSLog(@"%@",strPoi);
//            MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
//            annotation.title = poi.name;
//            annotation.subtitle = poi.tel;
//            annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
//            [_mapPOIArray addObject:poi];
//            [_mapView addAnnotation:annotation];
//        }

        AMapPOI * poi = _searchResultArray[indexPath.row];
        MyMapSearchTableViewCell *cell = [_searchTableView dequeueReusableCellWithIdentifier:@"searchCellId" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.lable1.text = poi.name;
        cell.label2.text = poi.address;
        
        return cell;
    
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_isSearch) {
        return _dataSouce.count;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_isSearch) {
        _headView = [[UIView alloc]init];
        _headView.tag = section + 1000;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 2, 20, 20)];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        CityNameModel *model = _dataSouce[section];
        lable.text = model.省;
        [_headView addSubview:lable];
        if ([_spreadOutArray[section] isEqualToString:@"0"]) {
            _imageView.image = [UIImage imageNamed:@"fold.png"];
        }else{
            _imageView.image = [UIImage imageNamed:@"unfold.png"];
        }
        
        [_headView addSubview:_imageView];
        _headView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [_headView addGestureRecognizer:tap];
        return _headView;
    }else{
        return nil;
    }
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld被点了",tap.view.tag);
    
    [_spreadOutArray replaceObjectAtIndex:tap.view.tag -1000 withObject:[NSString stringWithFormat:@"%d",![_spreadOutArray[tap.view.tag -1000]integerValue]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",[_spreadOutArray[tap.view.tag -1000]integerValue]]);
    [_cityTableView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag - 1000] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!_isSearch) {
        if (tableView != _cityTableView) {
            return nil;
        }
        return _spreadOutArray[section];
    }else{
        return nil;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isSearch) {
        CityNameModel *model = _dataSouce[indexPath.section];
        NSArray *arr = model.市;
        NSDictionary *dic = arr[indexPath.row];
        [_rightBarButton setTitle:dic[@"市名"] forState:UIControlStateNormal];
        _selectCityName = dic[@"市名"];
        [self touchRightBarButton];
        [self loadData];
    }else{
        AMapPOI * poi = _mapPOIArray[indexPath.row];
        NSLog(@"---- 1%@",poi.name);
//        NSLog(@"---- 2%@",poi.tel);
//        NSLog(@"---- 3%@",poi.address);
//        NSLog(@"---- 4%@",poi.parkingType);
//        NSLog(@"---- 5%ld",poi.distance);
//        NSLog(@"---- 6%@",poi.postcode);
//        NSLog(@"---- 7%@",poi.website);
//        NSLog(@"---- 8%@",poi.email);
//        NSLog(@"---- 9%@",poi.province);
//        NSLog(@"----10%@",poi.pcode);
//        NSLog(@"---11%@",poi.city);
//        NSLog(@"---12%@",poi.businessArea);
        SecondViewController2 *SVC2 = [[SecondViewController2 alloc]init];
        SVC2.title = poi.name;
        [self.navigationController pushViewController:SVC2 animated:YES];

    }
   
}

- (void)loadData{
    NSLog(@"数据加载中");
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"请稍候" status:@"数据加载中"];
    
    [self createMap];
    [_cityView removeFromSuperview];
    [self.view addSubview:_cityView];
    [MMProgressHUD dismissWithSuccess:@"数据加载完成"];
    
}
- (void)createMap
{
    [self createSearch];
    [self GeocodeSearchRequest];
    [MAMapServices sharedServices].apiKey = GaoDoAPP_KEY;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.delegate = self;
    _mapView.language = MAMapLanguageZhCN;
    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
    _mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    
    _mapView.showsCompass = YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 80); //设置指南针位置
    _mapView.showsScale = YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 80);  //设置比例尺位置
    //    //显示卫星地图
    //    _mapView.mapType = MAMapTypeSatellite;
    [self.view addSubview:_mapView];
   
}

- (void)location
{
    //获取正向地理编码得到的结果
    AMapTip *p = _response.geocodes.firstObject;
//    for (AMapTip *p in _response.geocodes) {
//        NSLog(@"========%@", p.location);
//        NSLog(@"========%@", p.district);
//        NSLog(@"========%@", p.adcode);
//    }
    
    //2).设置地图中心坐标点
    CLLocationCoordinate2D cl2d = CLLocationCoordinate2DMake(p.location.latitude,p.location.longitude);
    _mapView.centerCoordinate = cl2d;
    
   // 3)设置地图显示区域
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    MACoordinateRegion region = MACoordinateRegionMake(cl2d, span);
    _mapView.region = region;

    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [_mapView setZoomLevel:18 animated:YES];
    
}
- (void)createSearch{
    //初始化检索对象
    [AMapSearchServices sharedServices].apiKey = GaoDoAPP_KEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}
//正向地理编码
- (void)GeocodeSearchRequest{
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = CITY_NAME;
    geo.city = CITY_NAME;
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
}

//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    _response = response;
    [self location];
    if(response.geocodes.count == 0)
    {
        return;
    }
    [self POIAroundSearchRequest];
   
}
- (void)POIAroundSearchRequest{
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    if(_response.geocodes.count == 0)
    {
        NSLog(@"未找到此城市信息");
        return;
    }
    //p中存的是所选城市的信息
    for (AMapTip *p in _response.geocodes) {
//        NSLog(@"========%@", p.location);
//        NSLog(@"========%@", p.district);
//        NSLog(@"========%@", p.adcode);
//        NSLog(@"%@",p.district);
        request.location = p.location;
    }
    request.radius = 50000;
    
    // request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    //request.keywords = @"方恒";
    
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
}


//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    //POI所搜索到的结果pois
    for (AMapPOI *poi in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, poi.description];
        //NSLog(@"%@",strPoi);
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
        annotation.title = poi.name;
        annotation.subtitle = poi.tel;
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        [_mapPOIArray addObject:poi];
        [_mapView addAnnotation:annotation];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}
#pragma mark
#pragma mark - MAMapViewDelegate -
//针对每一个标注，生成对应的视图
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"like1hl.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}
//大头针被点击时调用方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"大头针被点击");

}
//大头针上的View被点击后调用的方法
- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{
    NSLog(@"大头针上的View被点击了");
    MAPointAnnotation *annotation = view.annotation;
    NSLog(@"%@",annotation.title);
    SecondViewController2 *SVC2 = [[SecondViewController2 alloc]init];
    SVC2.title = annotation.title;
    [self.navigationController pushViewController:SVC2 animated:YES];


}




//移动定位
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
#pragma mark -
#pragma mark UISearchResultsUpdating,UISearchControllerDelegate代理方法

//当搜索框内容变化或者UISearBar称为第一响应者时调用的代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取搜索框中的文本
    _searchText = self.searchController.searchBar.text;
    //获取搜索框中的文本
    NSString *searchText = self.searchController.searchBar.text;
    if(searchText.length == 0){
        //内容为空返回
        self.searchResultArray = [self.mapPOIArray mutableCopy];
        [self.searchTableView reloadData];
        return;
    }
      //AMapPOI * poi = _mapPOIArray[indexPath.row];
    NSMutableArray * marr = [[NSMutableArray alloc]init];
    for (AMapPOI *poi in _mapPOIArray) {
        [marr addObject:poi.name];
    }
    
    
    //执行搜索操作
    //filteredArrayUsingPredicate:使用一个谓词来过滤数组，谓词就是一个条件对象，该对象包含一个条件判断，要么为真，要么为假
    //凡时让谓词为真的内容都存放到数组中
    
    NSArray *arr = [marr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        //使用一个block来生成一个谓词，谓词中的第一个参数就是遍历到的数组中的某一项内容
        NSString *textInArray = (NSString*)evaluatedObject;
        //字符串查找，查找searchText 在 textInArray中的位置
        NSRange range = [textInArray rangeOfString:searchText];
        return (range.location != NSNotFound);
    }]];
    [_searchResultArray removeAllObjects];
    for (NSString *str in arr) {
        NSLog(@"----------------%@",str);
        for (AMapPOI *poi in _mapPOIArray) {
        
            if ([str isEqualToString:poi.name]) {
                [_searchResultArray addObject:poi];
            }
        }

    }
    
    [self.searchTableView reloadData];

}


- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    
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
