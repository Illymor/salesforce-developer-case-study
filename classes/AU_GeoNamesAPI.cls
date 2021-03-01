/*
 * Apex Utilities for GeoNames API calls. The error handling is based on the informations 
 * from http://www.geonames.org/export/webservice-exception.html
 * 
 * @date 28/02/2021
 * @author corentin romilly
 */
public with sharing class AU_GeoNamesAPI{

    public String route{get;set;}
    public Map<String, String> parameters{get;set;}
    public Map<String, Object> responseDetails{get;set;}
    public Boolean hasError{get;set;}
    public String errorMessage{get;set;}    

    
    /*
     * Constructor.
     * 
     * @param route API to call
     */
    public AU_GeoNamesAPI(String route){
        this.route = route;
        this.parameters = new Map<String, String>();
        this.responseDetails = new Map<String, Object>();
        this.hasError = false;
        this.errorMessage = null;
    }

    /*
     * Add a URL parameter to the API call.
     * 
     * @param name name of the parameter
     * @param value value of the parameter
     */
    public void addParam(String name, String value){
        this.parameters.put(name, value);
    }

    /*
     * Build and return the HTTP request.
     * 
     * @return httpRequest request to use for the API call
     */
    private HttpRequest buildRequest(){
        // final end point defition : base + route + parameters
        String endPoint = CORE_Constants.GEONAMESAPI_BASE + this.route;
        endPoint += '?username=' + CORE_Constants.GEONAMESAPI_USERNAME;
        for(String parameterName : this.parameters.keySet()){
            endPoint += '&' + parameterName + '=' + this.parameters.get(parameterName);
        }   

        // http request creation
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        return request;
    }

    
    /*
     * Execute the API call and store the result. 
     * 
     * @return boolean false if the api call has an error
     */
    public Boolean call(){
        // execute the api call
        HttpRequest request = this.buildRequest();
        Http httpProtocol = new Http();
        HttpResponse response = httpProtocol.send(request);

        // get & parse the response
        String responseBody  = response.getBody();
        this.responseDetails = (Map<String, Object>)JSON.deserializeUntyped(responseBody);

        if( responseDetails.containsKey('status') ){
            // error occured (cf. http://www.geonames.org/export/webservice-exception.html)
            Map<String, Object> statusDetails = (Map<String, Object>)responseDetails.get('status');
            this.hasError = true;
            String errorMessage = String.valueOf( statusDetails.get('message') );
            String errorCode =  String.valueOf( statusDetails.get('value') );

            // store the error details
            this.errorMessage ='Error on calling API, "' + errorMessage + '" (code '+ errorCode + ').';
        }

        return !this.hasError;
    }
}