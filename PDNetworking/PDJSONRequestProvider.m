#import "PDJSONRequestProvider.h"


@interface PDJSONRequestProvider ()

@property (nonatomic) NSURLComponents *URLComponents;

@end


@implementation PDJSONRequestProvider

- (instancetype)initWithURLComponents:(NSURLComponents *)URLComponents
{
    self = [super init];
    if (self) {
        self.URLComponents = URLComponents;
    }
    return self;
}

- (NSURLRequest *)requestWithHTTPMethod:(NSString *)httpMethod
                                   path:(NSString *)path
{
    NSURL *baseURL = [self.URLComponents URL];
    NSURL *URL = [baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = httpMethod;
    return request;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
