#import "PDRequestProvider.h"


@class PDParameterToQueryStringEncoder;


@interface PDJSONRequestProvider : NSObject <PDRequestProvider>

- (instancetype)init __attribute__((unavailable("Please use initWithURLComponents:parameterEncoder: when initializing PDRequestProvider")));

- (id)initWithURLComponents:(NSURLComponents *)URLComponents
           parameterEncoder:(PDParameterToQueryStringEncoder *)parameterEncoder;

@end
