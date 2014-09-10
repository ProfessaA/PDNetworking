#import "PDJSONRequestProvider.h"
#import "PDParameterToQueryStringEncoder.h"


@interface PDJSONRequestProvider ()

@property (nonatomic) NSURLComponents *URLComponents;
@property (nonatomic) PDParameterToQueryStringEncoder *parameterEncoder;

@end


@implementation PDJSONRequestProvider

- (id)initWithURLComponents:(NSURLComponents *)URLComponents
           parameterEncoder:(PDParameterToQueryStringEncoder *)parameterEncoder
{
    self = [super init];
    if (self) {
        self.URLComponents = URLComponents;
        self.parameterEncoder = parameterEncoder;
    }
    return self;
}

#pragma mark - <PDRequestProvider>

- (NSURLRequest *)requestWithHTTPMethod:(NSString *)HTTPMethod
                                   path:(NSString *)path
                             parameters:(NSDictionary *)parameters
{
    if ([HTTPMethod isEqualToString:@"POST"]) {
        return [self postRequestWithPath:path parameters:parameters];
    }
    else if ([HTTPMethod isEqualToString:@"GET"]) {
        return [self getRequestWithPath:path parameters:parameters];
    }
    else if ([HTTPMethod isEqualToString:@"DELETE"]) {
        return [self deleteRequestWithPath:path parameters:parameters];
    }
    else if ([HTTPMethod isEqualToString:@"PUT"]) {
        return [self putRequestWithPath:path parameters:parameters];
    }
    return nil;
}

#pragma mark - Private

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"POST"];
    
    NSUInteger bodyDataLength = 0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (parameters) {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        bodyDataLength = [bodyData length];
        [request setHTTPBody:bodyData];
    }
    
    NSString *bodyDataLengthString = [NSString stringWithFormat:@"%lu", (unsigned long)bodyDataLength];
    [request setValue:bodyDataLengthString forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

- (NSURLRequest *)putRequestWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"PUT"];
    
    NSUInteger bodyDataLength = 0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (parameters) {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        bodyDataLength = [bodyData length];
        [request setHTTPBody:bodyData];
    }
    
    NSString *bodyDataLengthString = [NSString stringWithFormat:@"%lu", (unsigned long)bodyDataLength];
    [request setValue:bodyDataLengthString forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"GET"];
    if (parameters) {
        NSString *query = [self.parameterEncoder encodedQueryStringWithParams:parameters];
        NSString *urlString = [NSString stringWithFormat:@"%@?%@", request.URL.absoluteString, query];
        NSURL *url = [NSURL URLWithString:urlString];
        request.URL = url;
    }
    return request;
}

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                             parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"DELETE"];
    return request;
}

- (NSMutableURLRequest *)mutableURLRequestWithPath:(NSString *)path
                                        httpMethod:(NSString *)httpMethod
{
    NSURL *baseURL = [self.URLComponents URL];
    NSURL *URL = [baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:URL];
    [mutableURLRequest setHTTPMethod:httpMethod];
    [mutableURLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return mutableURLRequest;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
