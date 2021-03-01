/*
 * Apex Utilities for parsing GeoNames Address (find coordinates from city and postal code), based on the 
 * API http://api.geonames.org/geoCodeAddressJSON.
 * 
 * The Class is used by Lightning Component.
 * 
 * @date 28/02/2021
 * @author corentin romilly
 */
public with sharing class AU_GeoNamesAddress {

    @AuraEnabled
    public String latitude{get;set;}
    @AuraEnabled
    public String longitude{get;set;}

    /*
     * Constructor.
     * 
     * @param details contains response body after calling the API
     */
    public AU_GeoNamesAddress(Map<String, Object> details){
        if( details.containsKey('address') ){
            Map<String, Object> addressAttributes = (Map<String, Object>) details.get('address');
            if( !addressAttributes.isEmpty() ) {
                if( addressAttributes.containsKey('lat') ){
                   this.latitude = String.valueOf( addressAttributes.get('lat') );
                }
                if( addressAttributes.containsKey('lng') ){
                    this.longitude = String.valueOf( addressAttributes.get('lng') );
                }
            }else{
                throw new AuraHandledException('Unable to retrieve coordinates (lat;long) from this location');
            }
            
        }else{
            throw new AuraHandledException('Unable to retrieve coordinates (lat;long) from this location');
        }
    }
}