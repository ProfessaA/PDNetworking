#import "PDRequester.h"


@interface PDJSONClient : NSObject <PDRequester>

- (instancetype)init __attribute__((unavailable("Please use initWithRequester:deserializeQueue:errorDomain: when initializing PDJSONClient")));

- (instancetype)initWithRequester:(id<PDRequester>)requester;

@end
