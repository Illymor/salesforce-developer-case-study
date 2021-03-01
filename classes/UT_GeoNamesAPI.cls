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

        List<Contact> contacts = new List<Contact>();

        Contact contact1 = new Contact();
        contact1.FirstName = 'Contact';
        contact1.LastName = 'Test 1';
        contact1.Email = 'email1@test.com';
        contact1.AccountId = account.Id;
        contacts.add( contact1 );

        Contact contact2 = new Contact();
        contact2.FirstName = 'Contact';
        contact2.LastName = 'Test 2';
        contact2.Email = 'email2@test.com';
        contact2.AccountId = account.Id;
        contacts.add( contact2 );

        insert contacts;
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

    /*
     * Test 3 / Email sending
     */
    @isTest
    public static void testEmailSendingToContacts(){
        Account account = [select Id from Account where Name = 'Account Test 1'];

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new UT_GeoNamesAPIMock());
        AU_GeoNamesWeatherObservation weatherObservation = AW_WeatherInformationsAPI.getWeatherInformations('47.21654', '-1.55062');
        Integer counter = AW_WeatherInformationsAPI.sendWeatherReport(weatherObservation, account.Id);

        Test.stopTest();

        System.assert(counter == 2);
    }
}
