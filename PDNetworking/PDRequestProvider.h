#import <Foundation/Foundation.h>


@protocol PDRequestProvider <NSObject>

- (NSURLRequest *)requestWithHTTPMethod:(NSString *)HTTPMethod
                                   path:(NSString *)path
                             parameters:(NSDictionary *)parameters;

@end
