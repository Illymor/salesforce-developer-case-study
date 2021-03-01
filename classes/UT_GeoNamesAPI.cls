/*
 * Unit Test class for the GeoNames API. (API Mock : cf. "UT_GeoNamesAPIMock")
 *  
 * @date 28/02/2021
 * @author corentin romilly
 */
@isTest
public with sharing class UT_GeoNamesAPI {

    /*
     * Data creation.
     */
    @testSetup
    static void prepareData(){
        Account account = new Account();
        account.Name = 'Account Test 1';
        account.BillingCity = 'NANTES';
        account.BillingPostalCode = '44000';
        insert account;
    }

    /*
     * Test 1 / Weather information
     */
    @isTest
    public static void testWeatherObservationAPI(){
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new UT_GeoNamesAPIMock());
        AU_GeoNamesWeatherObservation weatherObservation = AW_WeatherInformationsAPI.getWeatherInformations('47.21654', '-1.55062');

        Test.stopTest();

        System.assert( weatherObservation.humidity == '65%' );
        System.assert( weatherObservation.temperature == '15°C' );
        System.assert( weatherObservation.windSpeed == '20 Knots' );
        System.assert( weatherObservation.icon == 'clouds' );
    }

    /*
     * Test 2 / Geocoding address
     */
    @isTest
    public static void testAddressGeolocationAPI(){
        Account account = [select Id from Account where Name = 'Account Test 1'];

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new UT_GeoNamesAPIMock());
        AU_GeoNamesAddress address = AW_WeatherInformationsAPI.getAccountGeolocation(account.Id);

        Test.stopTest();

        System.assert(address.latitude == '47.21654');
        System.assert(address.longitude == '-1.55062');
    }
}