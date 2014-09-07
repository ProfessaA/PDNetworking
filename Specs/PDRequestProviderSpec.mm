#import "CDRSpecHelper.h"
#import "PDJSONRequestProvider.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDJSONRequestProviderSpec)

describe(@"PDJSONRequestProvider", ^{
    __block PDJSONRequestProvider *subject;
    __block NSURLComponents *urlComponents;

    beforeEach(^{
        urlComponents = [NSURLComponents componentsWithString:@"https://example.com/api/v1/"];
        subject = [[PDJSONRequestProvider alloc] initWithURLComponents:urlComponents];
    });
    
    it(@"should provide a request given an http method and a path", ^{
        NSURLRequest *request = [subject requestWithHTTPMethod:@"GET" path:@"cars"];
        request.HTTPMethod should equal(@"GET");
        [request.URL absoluteString] should equal(@"https://example.com/api/v1/cars");
    });
    
});

SPEC_END
