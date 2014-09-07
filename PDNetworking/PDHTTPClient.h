#import "PDRequester.h"


FOUNDATION_EXPORT NSString *const PDHTTPClientErrorDataKey;


@interface PDHTTPClient : NSObject <PDRequester>

- (instancetype)init __attribute__((unavailable("Please use initWithRequester:acceptableStatusCodes:errorDomain: when initializing PDHTTPClient")));

- (instancetype)initWithRequester:(id<PDRequester>)requester
            acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes
                      errorDomain:(NSString *)errorDomain;

@end
