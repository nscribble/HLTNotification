//
//  HLTNotificationSlideContentView.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/20.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationSlideContentView.h"
#import "HLTNotification.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import "UIColor+Ext.h"

#define STATUS_BAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)

#pragma mark - HLTNotificationSlideViewLayout

@interface HLTNotificationSlideViewLayout ()

@end

@implementation HLTNotificationSlideViewLayout

- (instancetype)initWithNotification:(HLTNotification *)notification {
    if (self = [super init]) {
        NSDictionary *payload = notification.payload;
        _title = payload[@"title"];
        _subtitle = payload[@"subtitle"];
        _avatarURL = [NSURL URLWithString:payload[@"avatar"]];
    }
    
    return self;
}

@end

#pragma mark - HLTNotificationSlideContentView

// 自定义界面
@interface HLTNotificationSlideContentView ()

// 布局信息
@property (nonatomic, strong) HLTNotificationSlideViewLayout *layout;

// 内容Container
@property (nonatomic,strong) UIView     *containerView;
// 头像
@property (nonatomic,strong) UIImageView    *avatarImageView;
// 标题
@property (nonatomic,strong) UILabel        *titleLabel;
// 副标题
@property (nonatomic,strong) UILabel        *subtitleLabel;

@end

@implementation HLTNotificationSlideContentView

+ (instancetype)contentViewForLayout:(HLTNotificationSlideViewLayout *)layout {
    HLTNotificationSlideContentView *contentView = [self new];
    contentView.layout = layout;
    
    return contentView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && !self.superview) {
        [self __addSubviews];
    }
}

- (void)__addSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.containerView];// wrapper
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10+STATUS_BAR_HEIGHT, 20/2, 0, 20/2));
    }];
    
    UIView *textView = [UIView new];
    [self.containerView addSubview:textView];
    [self.containerView addSubview:self.avatarImageView];
    [textView addSubview:self.titleLabel];
    [textView addSubview:self.subtitleLabel];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
        make.left.mas_equalTo(30/2);
        make.width.height.mas_equalTo(80/2);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(10);
        make.right.equalTo(self.containerView.mas_right).offset(-10);
        make.centerY.equalTo(self.containerView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(textView);
    }];

    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20/2-3);
    }];
    
    UIImageView *avatarImageView = self.avatarImageView;
    [avatarImageView sd_setImageWithURL:self.layout.avatarURL
                       placeholderImage:nil
                                options:SDWebImageRetryFailed
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              }];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 14/2 - 2;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.titleLabel.text = self.layout.title;
    self.subtitleLabel.text = self.layout.subtitle;
}


#pragma mark - 属性

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        _containerView.layer.cornerRadius = 20/2;
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerView.layer.shadowOpacity = 0.2f;
        _containerView.layer.shadowRadius = 20.0/2;
    }
    
    return _containerView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        
        _avatarImageView.layer.cornerRadius = 12/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        
        _titleLabel.font = [UIFont boldSystemFontOfSize:30/2];
        _titleLabel.textColor = HTColor(@"333333");
        
        [_titleLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        
        _subtitleLabel.font = [UIFont systemFontOfSize:24/2];
        _subtitleLabel.textColor = HTColor(@"999999");
        [_subtitleLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _subtitleLabel;
}

@end
