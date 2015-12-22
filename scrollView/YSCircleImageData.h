//
//  YSCircleImageData.h
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSInteger,YSImageType)
{
    YSImageTypeNet,
    YSImageTypeLocalImageName,
    YSImageTypeLocalImage
};

@interface YSCircleImageData : NSObject

@property (nonatomic,copy) NSString *netImageUrl;

@property (nonatomic,copy) NSString *localImageName;

@property (nonatomic,strong) UIImage *localImage;

@property (nonatomic,assign) YSImageType type;

@end
