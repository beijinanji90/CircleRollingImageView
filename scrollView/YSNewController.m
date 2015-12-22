//
//  YSNewController.m
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import "YSNewController.h"
#import "YSCircleRollView.h"

@implementation YSNewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *arrayData = [NSMutableArray array];
    for (int i = 1; i <= 7; i++) {
        YSCircleImageData *circleImageData = [[YSCircleImageData alloc] init];
        circleImageData.type = YSImageTypeLocalImageName;
        circleImageData.localImageName = [NSString stringWithFormat:@"%ld.jpg",(long)i];
        [arrayData addObject:circleImageData];
    }
    
    YSCircleImageData *circleImageData = [[YSCircleImageData alloc] init];
    circleImageData.type = YSImageTypeNet;
    circleImageData.netImageUrl = @"http://imghk0.geilicdn.com/test_instashop40683-1450174470092-1.png";
    [arrayData addObject:circleImageData];
    
    YSCircleRollView *rollView = [[YSCircleRollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    rollView->scrollTimeMargin = 3;
    [self.view addSubview:rollView];
    [rollView refreshCircleData:arrayData];
    
}

@end
