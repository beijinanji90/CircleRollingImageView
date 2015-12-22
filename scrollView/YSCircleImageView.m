//
//  YSCircleImageView.m
//  scrollView
//
//  Created by chenfenglong on 15/12/22.
//  Copyright © 2015年 YS. All rights reserved.
//

#import "YSCircleImageView.h"
#import "UIImageView+WebCache.h"

@interface YSCircleImageView ()

@property (nonatomic,weak) UIActivityIndicatorView *activityView;

@end
@implementation YSCircleImageView

- (void)setCircleImageData:(YSCircleImageData *)circleImageData
{
    _circleImageData = circleImageData;
    if (circleImageData.type == YSImageTypeNet)
    {
        __weak typeof(self) _weakSelf = self;
        NSURL *url = [NSURL URLWithString:circleImageData.netImageUrl];
        if (url)
        {
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _weakSelf.activityView.hidden = YES;
                [_weakSelf.activityView stopAnimating];
            }];
        }
    }
    else if (circleImageData.type == YSImageTypeLocalImage){
        [self setImage:circleImageData.localImage];
    }
    else if (circleImageData.type == YSImageTypeLocalImageName){
        [self setImage:[UIImage imageNamed:circleImageData.localImageName]];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllSubview];
    }
    return self;
}

- (void)addAllSubview
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.contentMode = UIViewContentModeCenter;
    activityView.hidesWhenStopped = YES;
    activityView.hidden = YES;
    [self addSubview:activityView];
    self.activityView = activityView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.activityView.frame = self.bounds;
}


@end
