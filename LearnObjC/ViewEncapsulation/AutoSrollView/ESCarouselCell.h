//
//  ESCarouselCell.h
//  LearnObjC
//
//  Created by eshore on 2017/8/1.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESCarouselCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
//@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign)CGRect titleLabelFrame;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@property (nonatomic, assign) BOOL hasConfigured;

@end
