//
//  PanachzApi.h
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PanachzApi : AFHTTPSessionManager

+ (PanachzApi *)getInstance;

@end
