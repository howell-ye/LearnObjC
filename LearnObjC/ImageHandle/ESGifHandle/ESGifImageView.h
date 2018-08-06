//
//  ESGifImageView.h
//  EShoreAppLib
//
//  Created by eshore on 2017/8/8.
//  Copyright © 2017年 EShore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESGifImageView : UIImageView

/**
 show gif with data of gif image

 @param gifData nsdata that you convert from you gif file
 @return a view within a gif
 */
- (instancetype)initWithGifData:(NSData *)gifData;


/**
 show gif with file path of local gif image

 @param filePath file path of your local gif file
 @return a view within a gif
 */
- (instancetype)initWithGifFilePath:(NSString *)filePath;

@end
