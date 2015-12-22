//
//  ViewController.m
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIImageView *imageView1;
@property (nonatomic,weak) UIImageView *imageView2;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *arrayImage;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger currentLeftIndex;
@property (nonatomic,assign) NSInteger currentRightIndex;

@end

@implementation ViewController

- (NSMutableArray *)arrayImage
{
    if (_arrayImage == nil) {
        _arrayImage = [NSMutableArray array];
        
        for (int i = 1; i <= 2; i++) {
            [_arrayImage addObject:[NSString stringWithFormat:@"%ld.jpg",(long)i]];
        }
    }
    return _arrayImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat heigth = 200;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(width * 2, heigth);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *image1 = [[UIImageView alloc] init];
    image1.backgroundColor = [UIColor redColor];
    image1.frame = CGRectMake(0, 0, width, heigth);
    [scrollView addSubview:image1];
    self.imageView1 = image1;
    
    UIImageView *image2 = [[UIImageView alloc] init];
    image2.backgroundColor = [UIColor greenColor];
    image2.frame = CGRectMake(width, 0, width, heigth);
    [scrollView addSubview:image2];
    self.imageView2 = image2;
    
    image1.image = [self imageNameByIndex:0];
    image2.image = [self imageNameByIndex:1];
    
    self.currentLeftIndex = 0;
    self.currentRightIndex = 1;
    
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 20;
    CGFloat pageControlX = (width - pageControlW) / 2;
    CGFloat pageControlY = (heigth - 10 - pageControlH);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    pageControl.numberOfPages = self.arrayImage.count;
    
    [self setUpTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
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

    if (x < 0)
    {
        self.imageView2.frame = tempImage2Frame;
        self.imageView1.frame = tempImage1Frame;
        
        self.currentRightIndex = self.currentLeftIndex;
        if (self.currentLeftIndex <= 0) {
            self.currentLeftIndex = self.arrayImage.count - 1;
        }
        else{
            self.currentLeftIndex -= 1;
        }
        
        if (self.imageView1.frame.origin.x == 0) {
            self.imageView1.image = [self imageNameByIndex:self.currentLeftIndex];
        }
        else{
            self.imageView2.image = [self imageNameByIndex:self.currentLeftIndex];
        }

        scrollView.contentOffset = CGPointMake(width - ABS(x), 0);
    }
    else if(x > width)
    {
        self.imageView2.frame = tempImage2Frame;
        self.imageView1.frame = tempImage1Frame;
        
        self.currentLeftIndex = self.currentRightIndex;
        if (self.currentRightIndex >= self.arrayImage.count - 1) {
            self.currentRightIndex = 0;
        }
        else{
            self.currentRightIndex += 1;
        }
        
        if (self.imageView1.frame.origin.x == 0) {
            self.imageView2.image = [self imageNameByIndex:self.currentRightIndex];
        }
        else{
            self.imageView1.image = [self imageNameByIndex:self.currentRightIndex];
        }
        scrollView.contentOffset = CGPointMake(x - width, 0);
    }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= scrollView.frame.size.width / 2)
    {
        self.pageControl.currentPage = self.currentRightIndex;
    }
    else
    {
        self.pageControl.currentPage = self.currentLeftIndex;
    }
    
    NSLog(@"%f -- %d -- %d",offsetX,self.currentLeftIndex,self.currentRightIndex);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setUpTimer];
}

- (void)setUpTimer {
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scorll {
    [self.scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
}

- (UIImage *)imageNameByIndex:(NSInteger)currentIndex
{
    NSString *imageName = [NSString stringWithFormat:@"%@",self.arrayImage[currentIndex]];
    return [UIImage imageNamed:imageName];
}


@end
