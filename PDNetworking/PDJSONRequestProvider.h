#import <Foundation/Foundation.h>


@interface PDJSONRequestProvider : NSObject

- (instancetype)init __attribute__((unavailable("Please use initWithURLComponents: when initializing PDRequestProvider")));

- (instancetype)initWithURLComponents:(NSURLComponents *)URLComponents;

- (NSURLRequest *)requestWithHTTPMethod:(NSString *)httpMethod
                                   path:(NSString *)path;

@end
