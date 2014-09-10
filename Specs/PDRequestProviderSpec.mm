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
        parameterEncoder = nice_fake_for([PDParameterToQueryStringEncoder class]);
        urlComponents = [NSURLComponents componentsWithString:@"https://example.com/api/v1/"];
        subject = [[PDJSONRequestProvider alloc] initWithURLComponents:urlComponents parameterEncoder:parameterEncoder];
    });
    
    it(@"should provide a request given an http method and a path", ^{
        parameterEncoder stub_method(@selector(encodedQueryStringWithParams:))
            .with(@{@"sort_by": @"price_ascending"})
            .and_return(@"sort_by=price_ascending");
        NSURLRequest *request = [subject requestWithHTTPMethod:@"GET" path:@"cars" parameters:@{@"sort_by": @"price_ascending"}];
        request.HTTPMethod should equal(@"GET");
        [request.URL absoluteString] should equal(@"https://example.com/api/v1/cars?sort_by=price_ascending");
    });
    
});

SPEC_END
