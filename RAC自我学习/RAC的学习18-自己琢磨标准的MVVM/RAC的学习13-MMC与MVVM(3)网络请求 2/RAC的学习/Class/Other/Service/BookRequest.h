//
//  BookRequest.h
//  RAC的学习
//
//  Created by Zhuo Wu on 09/04/2018.
//  Copyright © 2018 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface BookRequest : NSObject

- (RACSignal *)requestBookListWithURL:(NSString *)URLStr andParameter:(NSDictionary *)parameter;

@end
