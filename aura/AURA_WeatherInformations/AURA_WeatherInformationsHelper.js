({
    /*
     * Return a promise for working with the current user position.
     */
    getCurrentUserPosition : function() {
        return new Promise(function(resolve, reject) {
            navigator.geolocation.getCurrentPosition(function(position) {
                resolve(position);
            }, function(error){
                reject(error.message);
            });
        });
    }, 

    /* 
     * Return a promise for working with the current account position.
     */
    getAccountPosition : function(component, helper){
        return new Promise(function(resolve, reject) {
            var action = component.get('c.getAccountGeolocation');

            action.setParams({
                'accountId' : component.get('v.recordId')
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if( state === "SUCCESS" ){
                    resolve( response.getReturnValue() );
                }else{
                    var errors = response.getError();
                    var errorMessage = errors[0].message;
                    reject(errorMessage);
                }
            });

            $A.enqueueAction(action);
        });   
    }, 

    /*
     * Get the weather observation for the coordinates (lat;long) previously defined.
     */
    getWeatherObservations : function(component, helper){
        var action = component.get('c.getWeatherInformations');

        action.setParams({
            'latitude' : component.get('v.latitude'), 
            'longitude' : component.get('v.longitude')
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if( state === "SUCCESS" ){
                var weather = response.getReturnValue();
                component.set('v.weather', weather);
            }else{
                var errors = response.getError();
                var errorMessage = errors[0].message;
                helper.logError(component, 'We\'re unabled to retrieve the weather observation', errorMessage);
            }
        });

        $A.enqueueAction(action);
    }, 

    /* 
     * Send weather details by email to the contacts of the account or the current user.
     */
    sendEmails : function(component, helper){
        var action = component.get('c.sendWeatherReport');

        console.log('sendEmails', component.get('v.weather'));

        action.setParams({
            'weatherObservation' : component.get('v.weather'), 
            'accountId' : component.get('v.recordId')
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if( state === "SUCCESS" ){
                var emailReceiversNumber = response.getReturnValue();
                // display success toast
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Emails sent : " + emailReceiversNumber, 
                    "duration" : 3000
                });
                toastEvent.fire();
            }else{
                var errors = response.getError();
                var errorMessage = errors[0].message;
                helper.logError(component, 'We\'re unabled to retrieve the send emails', errorMessage);
            }
        });

        $A.enqueueAction(action);
    }, 

    /*
     * Display the current error to the user.
     */
    logError : function(component, userMessage, technicalDetails){
        component.set('v.errorMessage', 'Sorry, an error occured : ' + userMessage + '. More details : ' + technicalDetails);
    }
})