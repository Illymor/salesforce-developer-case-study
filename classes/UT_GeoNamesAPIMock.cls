/*
 * Unit Test class for the GeoNames API calls during apex tests. 
 *   
 * @date 28/02/2021
 * @author corentin romilly
 */
@isTest
global class UT_GeoNamesAPIMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        System.assert( request.getEndpoint().startsWith( CORE_Constants.GEONAMESAPI_BASE), 'URL d\'appel du WS incorrecte' );

        // creation of the API response
        String bodyResponse = '{}';
        if( request.getEndpoint().indexOf( CORE_Constants.GEONAMESAPI_ROUTE_WEATHERFINDNEAR ) > -1 ){
            // test for the weather observation API
            bodyResponse = '{ "weatherObservation":{ "windSpeed":"20","temperature":"15","humidity":"65","clouds":"few clouds","weatherCondition":"n/a" } }';
        }else{
            if( request.getEndpoint().indexOf( CORE_Constants.GEONAMESAPI_ROUTE_GEOCODEADDRESS ) > -1 ){
                // test for the geocoding API
                bodyResponse = '{ "address":{ "lat":"47.21654","lng":"-1.55062" } }';
            }
        }

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(bodyResponse);

        return response;
    }
}