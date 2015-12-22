//
//  YSCircleRollView.h
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCircleImageData.h"
#import "YSCircleImageView.h"

@protocol YSCircleRollViewDelegate <NSObject>

- (void)circleRollViewClick:(YSCircleImageData *)circleImageData;

@end

@interface YSCircleRollView : UIView
{
@public
    //默认为200
    CGFloat circleRollViewH;
    
    //page的正常模式颜色
    UIColor *pageIndicatorTintColor;
    
    //选中页码的颜色
    UIColor *currentPageIndicatorTintColor;
    
    //图片自动滚动间隔(如果为0，那么就不自动滚动)，默认两秒
    CGFloat scrollTimeMargin;
}

//这个数据中，需要是YSCircleImageData对象
- (void)refreshCircleData:(NSArray *)arrayCircleData;

//代理
@property (nonatomic,weak) id<YSCircleRollViewDelegate> delegate;

@end
