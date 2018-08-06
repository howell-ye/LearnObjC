//
//  AdvancedAnimationVCtlr.h
//  LearnObjC
//
//  Created by yehowell on 2017/7/18.
//  Copyright © 2017年 howell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvancedAnimationVCtlrDelegate <NSObject>

- (void)justTestSysnState;

@end

@interface AdvancedAnimationVCtlr : UIViewController

@property (nonatomic, weak) id<AdvancedAnimationVCtlrDelegate> delegate;

@end
