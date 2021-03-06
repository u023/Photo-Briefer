//
//  FKUploadRespone.h
//  FlickrKit
//
//  Created by David Casserly on 06/06/2013.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//


@interface FKUploadRespone : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong, readonly) NSString *photoID;
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;

- (BOOL) parse;

@end
