//
//  OrderJeansPreviewImageViewController.h
//  Panachz
//
//  Created by Peter Choi on 4/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderJeansPreviewImageViewController : UIViewController

@property (nonatomic, strong) NSString *previewUrl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
