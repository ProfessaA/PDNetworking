#import "CDRSpecHelper.h"
#import "PDJSONRequestProvider.h"
#import "PDParameterToQueryStringEncoder.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDJSONRequestProviderSpec)

describe(@"PDJSONRequestProvider", ^{
    __block PDJSONRequestProvider *subject;
    __block NSURLComponents *urlComponents;
    __block PDParameterToQueryStringEncoder *parameterEncoder;

    beforeEach(^{
        parameterEncoder = [[PDParameterToQueryStringEncoder alloc] initWithStringEncoding:NSUTF8StringEncoding];
        urlComponents = [NSURLComponents componentsWithString:@"https://example.com/api/v1/"];
        subject = [[PDJSONRequestProvider alloc] initWithURLComponents:urlComponents parameterEncoder:parameterEncoder];
    });
    
    it(@"should provide a request given an http method and a path, correctly serializing query string params for GET", ^{
        NSURLRequest *request = [subject requestWithHTTPMethod:@"GET" path:@"cars" parameters:@{@"sort_by": @"price_ascending"}];
        request.HTTPMethod should equal(@"GET");
        [request.URL absoluteString] should equal(@"https://example.com/api/v1/cars?sort_by=price_ascending");
    });

    it(@"should provide a request given an http method and a path, correctly serializing HTTP request body params for POST", ^{
        NSURLRequest *request = [subject requestWithHTTPMethod:@"POST" path:@"cars" parameters:@{@"sort_by": @"price_ascending"}];
        request.HTTPMethod should equal(@"POST");
        NSData *requestBodyData = request.HTTPBody;
        NSDictionary *requestBodyDictionary = [NSJSONSerialization JSONObjectWithData:requestBodyData options:NSJSONReadingAllowFragments error:nil];
        requestBodyDictionary should equal(@{@"sort_by": @"price_ascending"});
    });

    it(@"should provide no params if given nil parameters for POST", ^{
        NSURLRequest *request = [subject requestWithHTTPMethod:@"POST" path:@"cars" parameters:nil];
        request.HTTPMethod should equal(@"POST");
        request.HTTPBody should be_nil;
    });

    it(@"should provide no params if given nil parameters for GET", ^{
        NSURLRequest *request = [subject requestWithHTTPMethod:@"GET" path:@"cars" parameters:nil];
        request.HTTPMethod should equal(@"GET");
        [request.URL absoluteString] should equal(@"https://example.com/api/v1/cars");
    });
});

SPEC_END
