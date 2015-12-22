//
//  YSCircleRollView.m
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import "YSCircleRollView.h"

@interface YSCircleRollView ()<UIScrollViewDelegate>

//数据源
@property (nonatomic,strong) NSMutableArray *arrayCircleData;
@property (nonatomic,strong) NSTimer *timer;

//所需要的控件
@property (nonatomic,weak) YSCircleImageView *imageView1;
@property (nonatomic,weak) YSCircleImageView *imageView2;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

//左右两边的索引
@property (nonatomic,assign) NSInteger currentLeftIndex;
@property (nonatomic,assign) NSInteger currentRightIndex;

@end

@implementation YSCircleRollView

- (NSMutableArray *)arrayCircleData
{
    if (_arrayCircleData == nil) {
        _arrayCircleData = [NSMutableArray array];
    }
    return _arrayCircleData;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //默认的高度是200
        self->circleRollViewH = 200;
        
        //page的正常模式颜色
        self->pageIndicatorTintColor = [UIColor blackColor];
        
        //选中页码的颜色
        self->currentPageIndicatorTintColor = [UIColor whiteColor];
        
        //图片滚动之间间隔时间
        self->scrollTimeMargin = 2;
    }
    return self;
}

- (void)refreshCircleData:(NSArray *)arrayCircleData
{
    //先清除以前的默认值
    [self.arrayCircleData removeAllObjects];
    [self removeTimer];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (arrayCircleData == nil || arrayCircleData.count < 2) {
        NSException *excp = [NSException exceptionWithName:@"不支持" reason:@"数据源中至少需要两张图片" userInfo:nil];
        [excp raise];
        return;
    }
    
    //设置子控件
    [self.arrayCircleData addObjectsFromArray:arrayCircleData];
    [self setSubView];
    [self setControlValue];
    [self setUpTimer];
}

/*********设置子控件*********/
- (void)setSubView
{
    //公共变量
    CGFloat width = self.frame.size.width;
    CGFloat heigth = self->circleRollViewH;
    
    //ScrollVIew
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(width * 2, heigth);
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    //需要显示的两个ImageView
    YSCircleImageView *image1 = [[YSCircleImageView alloc] init];
    image1.backgroundColor = [UIColor lightGrayColor];
    image1.frame = CGRectMake(0, 0, width, heigth);
    [scrollView addSubview:image1];
    self.imageView1 = image1;
    
    YSCircleImageView *image2 = [[YSCircleImageView alloc] init];
    image2.backgroundColor = [UIColor lightGrayColor];
    image2.frame = CGRectMake(width, 0, width, heigth);
    [scrollView addSubview:image2];
    self.imageView2 = image2;
    
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 20;
    CGFloat pageControlX = (width - pageControlW) / 2;
    CGFloat pageControlY = (heigth - 10 - pageControlH);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    pageControl.pageIndicatorTintColor = self->pageIndicatorTintColor;
    pageControl.currentPageIndicatorTintColor = self->currentPageIndicatorTintColor;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)setControlValue
{
    //左边、右边的索引
    self.currentLeftIndex = 0;
    self.currentRightIndex = 1;
    self.imageView1.circleImageData = [self imageNameByIndex:self.currentLeftIndex];
    self.imageView2.circleImageData = [self imageNameByIndex:self.currentRightIndex];
    
    //页码个数
    self.pageControl.numberOfPages = self.arrayCircleData.count;
}

/*********Timer*********/
- (void)setUpTimer {
    if (self->scrollTimeMargin > 0) {
        _timer = [NSTimer timerWithTimeInterval:self->scrollTimeMargin target:self selector:@selector(scorll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else{
        [self removeTimer];
    }
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scorll {
    [self.scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
}

/*********UIScrollView的代理*********/
/*
    算法：
    1、不管有多少个图片，只会创建两个UIImageView
    2、图片拖拽，x一共会发生三种情况
        a、x < 0 这个需要把之前右边的图片拿到左边来
        b、x > width 这个需要把之前左边的图片拿到右边来
        c、0 < x < width 这个时候是不需要交换图片的
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    
    //因为如果这个X<0;x > width这两种情况，这两个的位置都是需要交换的
    CGRect tempImage1Frame = self.imageView1.frame;
    CGRect tempImage2Frame = self.imageView2.frame;
    if (tempImage1Frame.origin.x == 0)
    {
        tempImage2Frame.origin.x = 0;
        tempImage1Frame.origin.x = width;
    }
    else
    {
        tempImage2Frame.origin.x = width;
        tempImage1Frame.origin.x = 0;
    }
    
    //x < 0的情况，这个需要把之前右边的图片拿到左边来
    if (x < 0)
    {
        //把最右边的图片拿到左边来，相当于交换两个的位置
        self.imageView2.frame = tempImage2Frame;
        self.imageView1.frame = tempImage1Frame;
        
        //这点很重要，因为把以前右边的图片拿到了左边，那么以前左边的图片现在就变成右边了
        //所以需要leftIndex/rightIndex都需要修改
        self.currentRightIndex = self.currentLeftIndex;
        if (self.currentLeftIndex <= 0) {
            self.currentLeftIndex = self.arrayCircleData.count - 1;
        }
        else{
            self.currentLeftIndex -= 1;
        }
        
        //这个时候需要判断哪个imageView在左边，这个时候需要把新的对应图片赋值给他
        //右边的imageView的图片不需要发生变化
        if (self.imageView1.frame.origin.x == 0) {
            self.imageView1.circleImageData = [self imageNameByIndex:self.currentLeftIndex];
        }
        else{
            self.imageView2.circleImageData = [self imageNameByIndex:self.currentLeftIndex];
        }
        
        //然后模拟在两个图片都不超过边界的情况的滚动
#warning mark -- 这个地方比较难理解
        scrollView.contentOffset = CGPointMake(width - ABS(x), 0);
    }
    else if(x > width)
    {
        //把最右边的图片拿到左边来，相当于交换两个的位置
        self.imageView2.frame = tempImage2Frame;
        self.imageView1.frame = tempImage1Frame;
        
        //因为以前的左边图片拿到了右边了，所以以前的右边图片就变成左边了
        self.currentLeftIndex = self.currentRightIndex;
        if (self.currentRightIndex >= self.arrayCircleData.count - 1) {
            self.currentRightIndex = 0;
        }
        else{
            self.currentRightIndex += 1;
        }
        
        if (self.imageView1.frame.origin.x == 0) {
            self.imageView2.circleImageData = [self imageNameByIndex:self.currentRightIndex];
        }
        else{
            self.imageView1.circleImageData = [self imageNameByIndex:self.currentRightIndex];
        }
        scrollView.contentOffset = CGPointMake(x - width, 0);
    }
    
    //这个需要根据scrollView的滚动量，来显示pageControl
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= scrollView.frame.size.width / 2)
    {
        self.pageControl.currentPage = self.currentRightIndex;
    }
    else
    {
        self.pageControl.currentPage = self.currentLeftIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //如果被拖拽了，那么就取消定时器
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //停止拖拽后，那么就开始定时器
    [self setUpTimer];
}

- (YSCircleImageData *)imageNameByIndex:(NSInteger)currentIndex
{
    YSCircleImageData *circleImageData = self.arrayCircleData[currentIndex];
    return circleImageData;
}

@end
