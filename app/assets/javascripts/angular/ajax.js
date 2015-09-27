angular.module('ajax', []);

angular.module('ajax').factory('Ajax', function($http){
    return {
        get: function(url, params){
            if(!params){
                params = {};
            }
            return $http({
                method: 'GET',
                url: url,
                params: params 
            });
        },
        post: function(url, params, csrf){
            if(!params){
                params = {};
            }
            return $http({
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json', 
                    'X-CSRF-Token': csrf 
                },
                url: url,
                data: params 
            });
        }
    };
});
