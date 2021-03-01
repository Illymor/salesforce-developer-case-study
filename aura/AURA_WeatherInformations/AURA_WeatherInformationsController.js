({
    /*
     * Actions on component initialization : 
     *  > if "recordId" is defined, retrieve longitude/latitude from account billing city/billing postal code.
     *  > else, retrieve longitude/latitude of current user location.
     *  > then, query and display weather informations (from http://geonames.org) for the longitude/latitude. 
     */
    onInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        if(recordId == null){
            // accound id is empty

            // component is running in global context, try to retrieve current user position
            helper.getCurrentUserPosition().then(
                function(position){
                    // success, store coordinates & call weather info. API
                    component.set('v.latitude', position.coords.latitude );
                    component.set('v.longitude', position.coords.longitude );

                    helper.getWeatherObservations(component, helper);

            },  function(errorMessage){
                    // error 
                    helper.logError(component, 'We\'re unabled to detect your current location', errorMessage);
            });

        }else{

            // component is running for a specific account, query the longitude/latitude of 
            // this account, from the city and postal code 
            helper.getAccountPosition(component, helper).then(
                function(geoCodeAddress){
                    // success, store coordinates & call weather info. API
                    component.set('v.latitude', geoCodeAddress.latitude );
                    component.set('v.longitude', geoCodeAddress.longitude  );

                    helper.getWeatherObservations(component, helper);

            },  function(errorMessage){
                helper.logError(component, 'Unable to find the account location', errorMessage);
            });
        }
    }, 

    /*
     * Actions on click the button : 
     *  > send weather obs. by email to the contacts linked to the account (if component is running for a specific account)
     *  > or, send  weather obs. by email to the current user
     */
    onClickSendEmailsButton : function(component, event, helper) {
        helper.sendEmails(component, helper);
    }
})