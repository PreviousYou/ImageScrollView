//
//  ViewController.m
//  Task
//
//  Created by PreviousWang on 16/1/22.
//  Copyright © 2016年 PreviousWang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
/**
 *滑动视图
 */
@property(nonatomic,strong)UIScrollView *homeScrollView;
/**
 *页面控制视图
 */
@property(nonatomic,strong)UIPageControl *pageC;
/**
 *图片数组
 */
@property(nonatomic,strong)NSArray *imageURLArray;
/**
 *定时器
 */
@property(nonatomic,strong)NSTimer *timer;
/**
 *标号
 */
@property(nonatomic)int index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageURLArray=@[@"6",@"1",@"2",@"3",@"4",@"5",@"6",@"1"];
    
    _homeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 260)];
    _homeScrollView.tag = 100;
    //    设置分页显示
    _homeScrollView.pagingEnabled = YES;
    //    _HomeScrollView.contentSize = CGSizeMake(kScreenWidth*7, 20);
    
    //    隐藏水平的滚动条
    _homeScrollView.contentOffset=CGPointMake(self.view.frame.size.width, 0);
    _homeScrollView.showsHorizontalScrollIndicator=NO;
    _homeScrollView.delegate=self;
    [self.view addSubview:_homeScrollView];
    //    单击按下，单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_homeScrollView addGestureRecognizer:singleTap];
    
    //   设置PageController     分页数 圆点
    _pageC=[[UIPageControl alloc]initWithFrame:CGRectMake(0, _homeScrollView.frame.size.height-30, self.view.frame.size.width, 30)];
    
    _pageC.numberOfPages=_imageURLArray.count-2;
    _pageC.currentPage=0;
    
    
    [_pageC addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_pageC];
    
    _homeScrollView.contentSize = CGSizeMake(self.view.frame.size.width*_imageURLArray.count, 20);
    for (int i=0; i<_imageURLArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, _homeScrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        NSString *string=_imageURLArray[i];
        imageView.image=[UIImage imageNamed:string];
        [_homeScrollView addSubview:imageView];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
}

// 手势事件，点击后进入详情界面
-(void)singleTap{
    
    NSString *string =[NSString stringWithFormat:@"%d",self.index];
    
    NSLog(@"%@",string);
}

-(void)timerAct{
    
    //    播放下一张
    
    float x = _homeScrollView.contentOffset.x;
    
    [_homeScrollView scrollRectToVisible:CGRectMake(x+self.view.frame.size.width, 0, self.view.frame.size.width, _homeScrollView.frame.size.height) animated:YES];
}

- (void)pageAction:(UIPageControl *)pageControl{
    
    int page =(int)pageControl.currentPage;
    
    int offsetX = page * self.view.frame.size.width;
    
    [_homeScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if( _timer){
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
}

//  循环滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.index=scrollView.contentOffset.x/self.view.frame.size.width;
    
    int page = _homeScrollView.contentOffset.x /self.view.frame.size.width;
    _pageC.currentPage = page-1;
    
    if (_pageC==0) {
        _pageC.currentPage = _imageURLArray.count-3;
        
    }
    
    if (page ==_imageURLArray.count-1) {
        
        _pageC.currentPage = 0;
        
    }
    //    当滚动到 添加的两张图片的时候，跳转位置 0->5  6->1
    if (_homeScrollView.contentOffset.x == 0) {
        _homeScrollView.contentOffset = CGPointMake((_imageURLArray.count-2)*self.view.frame.size.width, 0);
    }
    
    if (_homeScrollView.contentOffset.x == self.view.frame.size.width*(_imageURLArray.count-1)) {
        _homeScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    }
}

@end
