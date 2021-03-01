/*
 * Apex Utilities for parsing GeoNames Weather Observation, based on the 
 * API https://www.geonames.org/export/JSON-webservices.html#findNearByWeatherJSON.
 * 
 * The Class is used by Lightning Component.
 * 
 * @date 28/02/2021
 * @author corentin romilly
 */
public with sharing class AU_GeoNamesWeatherObservation {

    @AuraEnabled
    public String windSpeed{get;set;} // unity : knots
    @AuraEnabled
    public String temperature{get;set;} // unity : celsius
    @AuraEnabled
    public String humidity{get;set;} // unity : pourcentage
    @AuraEnabled
    public String icon{get;set;} // cf. static ressource "WeatherIcons"

    /*
     * Default constructor.
     */
    public AU_GeoNamesWeatherObservation(){}

    /*
     * Constructor.
     * 
     * @param details contains response body after calling the API
     */
    public AU_GeoNamesWeatherObservation(Map<String, Object> details){
        this.windSpeed = 'n/a';
        this.temperature = 'n/a';
        this.humidity = 'n/a';
        this.icon = 'n/a';

        if( details.containsKey('weatherObservation') ){
            Map<String, Object> observations = (Map<String, Object>) details.get('weatherObservation');
            if( !observations.isEmpty() ){

                if( observations.containsKey('windSpeed') ){
                    this.windSpeed = String.valueOf( observations.get('windSpeed') ) + ' Knots';
                }

                if( observations.containsKey('temperature') ){
                    this.temperature = String.valueOf( observations.get('temperature') ) + '°C';
                }

                if( observations.containsKey('humidity') ){
                    this.humidity = String.valueOf( observations.get('humidity') ) + '%';
                }

                // set the icon name (sun, snow, mist, rain or clouds) based on the informations 
                // from the following pages 
                //  > https://www.geonames.org/export/JSON-webservices.html#findNearByWeatherJSON
                //  > http://forum.geonames.org/gforum/posts/list/28.page
                if( observations.containsKey('weatherCondition') && observations.containsKey('clouds') ){
                    String weatherCondition = String.valueOf( observations.get('weatherCondition') );
                    String clouds = String.valueOf( observations.get('clouds') );
                    String icon = null;

                    if( weatherCondition.contains('rain') ){
                        icon = 'rain';
                    }else{
                        if( weatherCondition.contains('snow') || weatherCondition.contains('ice') ){
                            icon = 'snow';
                        }else{
                            if( weatherCondition.contains('drizzle') || weatherCondition.contains('mist') || weatherCondition.contains('fog') ){
                                icon = 'mist';
                            }else{
                                if( clouds == 'few clouds' || clouds == 'scattered clouds' || clouds == 'broken clouds' || clouds == 'overcast' ){
                                    icon = 'clouds';
                                }else{
                                    icon = 'sun';
                                }
                            }
                        }
                    }
                    this.icon = icon;
                }
            }else{
                throw new AuraHandledException('No any weather observation found');
            }
            
        }else{
            throw new AuraHandledException('No any weather observation found');
        }
    }
}