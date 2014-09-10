#import "PDRequestProvider.h"


@interface PDJSONRequestProvider : NSObject <PDRequestProvider>

- (instancetype)init __attribute__((unavailable("Please use initWithURLComponents: when initializing PDRequestProvider")));

- (instancetype)initWithURLComponents:(NSURLComponents *)URLComponents;

- (NSURLRequest *)requestWithHTTPMethod:(NSString *)HTTPMethod
                                   path:(NSString *)path
                             parameters:(NSDictionary *)parameters;

@end
