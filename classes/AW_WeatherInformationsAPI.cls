/*
 * Apex Web Services Controller for the Lightning Component "AURA_WeatherInformations".
 * 
 * @date 28/02/2021
 * @author corentin romilly
 */
public with sharing class AW_WeatherInformationsAPI {

    /* 
     * Get longitude/latitude of on accound record. The geolocation (longitude and latitude) is found from billing 
     * city and billing postal, throw the following API : http://api.geonames.org/geoCodeAddressJSON
     * 
     * @param accoundId ID of the accound record
     * @return AU_GeoNamesAddress address class with longitude and latitude
     */
    @AuraEnabled
    public static AU_GeoNamesAddress getAccountGeolocation(Id accountId){
        Account account;

        try{
            account = [select BillingCity, BillingPostalCode from Account where Id = :accountId];
        }catch(Exception unknowAccountException){
            // account ID is invalid
            throw new AuraHandledException( 'Account not found' );
        }

        if(account.BillingCity == null || account.BillingPostalCode == null){
            // accound adresse (city or postal code) is invalid
            throw new AuraHandledException( 'Billing city and billing postal code have to be defined ' );
        }

        // call geonames api from geocoding the city/postal code of the account
        AU_GeoNamesAPI api = new AU_GeoNamesAPI( CORE_Constants.GEONAMESAPI_ROUTE_GEOCODEADDRESS );
        api.addParam('q', account.BillingCity);
        api.addParam('postalcode', account.BillingPostalCode);

        Boolean result = api.call();
        if( !result ){
            // error calling the api
            throw new AuraHandledException( api.errorMessage );
        }

        return new AU_GeoNamesAddress( api.responseDetails );
    }

    /* 
     * Get the weather condition at a given point, based on the following API : http://api.geonames.org/findNearByWeatherJSON
     * 
     * @param latitude latitude of the point
     * @param longitude longitude of the point 
     * @return AU_GeoNamesWeatherObservation weather class with weather informations to display (temperature, humidity, wind speed and global icon)
     */
    @AuraEnabled
    public static AU_GeoNamesWeatherObservation getWeatherInformations(String latitude, String longitude){
        AU_GeoNamesAPI api = new AU_GeoNamesAPI( CORE_Constants.GEONAMESAPI_ROUTE_WEATHERFINDNEAR );
        api.addParam('lat', latitude);
        api.addParam('lng', longitude);

        Boolean result = api.call();
        if( !result ){
            throw new AuraHandledException( api.errorMessage );
        }

        return new AU_GeoNamesWeatherObservation( api.responseDetails );
    }

    /* 
     * 
     * 
     * @param accountId
     */
    @AuraEnabled
    public static Integer sendWeatherReport(AU_GeoNamesWeatherObservation weatherObservation, Id accountId){
        // set of email receivers ID (contacts or user)
        Set<Id> targetObjectIDs = new Set<Id>();

        if( accountId != null ){
            // send weather report to contacts of the account 
            try{
                // update the last send date
                Account account = [select LastWeatherReportSendDate__c, (select Email from Contacts where Email != null) from Account where Id = :accountId];
                account.LastWeatherReportSendDate__c = Date.today();
                update account;

                for(Contact contact : account.Contacts){
                    targetObjectIDs.add( contact.Id );
                }
            }catch(Exception unknowAccountException){}
        }else{
            // send weather report to current user
            try{
                // update the last send date
                User user = [select LastWeatherReportSendDate__c from User where Id = :UserInfo.getUserId()];
                user.LastWeatherReportSendDate__c = Date.today();
                update user;

                targetObjectIDs.add( UserInfo.getUserId() );
            }catch(Exception unknowAccountException){}
        }

        if( targetObjectIDs.size() > 0 ){
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(Id targetObjectID : targetObjectIDs){
                // for each target object (contact or user), create the email with weather details
                String emailBody = 'Hello, ';
                emailBody += '<br>Please find the weather report you asked :';
                emailBody += '<br> > temperature : ' + weatherObservation.temperature;
                emailBody += '<br> > humidity : ' + weatherObservation.humidity;
                emailBody += '<br> > wind speed : ' + weatherObservation.windSpeed;
                emailBody += '<br> > trend : ' + weatherObservation.icon;

                Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
                singleEmail.setSubject('Salesforce Developer Case Study : Weather Report');
                singleEmail.setHtmlBody(emailBody);
                singleEmail.setPlainTextBody(emailBody);
                singleEmail.setTargetObjectId(targetObjectID);
                singleEmail.setTreatTargetObjectAsRecipient(true);
                singleEmail.setSaveAsActivity(false);

                emails.add( singleEmail );
            }
            // send all emails
            Messaging.sendEmail(emails);
        }

        // return number of email receivers
        return targetObjectIDs.size();
    }
}