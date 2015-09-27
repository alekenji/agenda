angular.module('app', ['ajax']);

angular.module("app").factory('TODOApi', function(Ajax){
    return {
        schedules_action: function(task, csrf){
            return Ajax.post('/api/schedules/', task, csrf);
        }
     };
});

angular.module("app").factory('TODOModel', function(TODOApi){
    var m = {
        newtask: '',
        showAgendar: false,
        showClear: false,
        todos: [],
        agenda: []
    };
    
    m.addnew = function(){

        if ( m.newtask != '' ) {
        	m.showAgendar = true;

            var todo = {
              task: m.newtask,
            };
            
            m.todos.push(todo);
            m.newtask = '';
        };

    };

    m.remove = function(index){

        var todo = m.todos[index];
        todo.removing = true;
        m.todos.splice(index, 1);

        if (m.todos.length <= 0 ) {
        	m.showAgendar = false;
            m.agenda = [];
            m.showClear   = false;
        }
    };

    m.schedule = function(){

    	var stringTask = '';
    	var csrf = '';
        m.agenda = [];
        m.showClear = false;

    	for (var idx = 0; idx < m.todos.length; idx++) {
    		stringTask += m.todos[idx].task+'||';	
    	};
        stringTask = { task: stringTask };

        csrf = $('meta[name="csrf-token"]').attr('content');

    	TODOApi.schedules_action(stringTask, csrf).success(function(result){ 
    		m.agenda = result;
    		m.showClear = true;	
    	});
    	
    };

    m.clear = function(){

    	m.agenda = [];
    	m.showClear = false;

    };

    return m;  

});


angular.module("app").controller('myCtrl', function ($scope, TODOModel){

	var m = $scope.m = TODOModel;

    $scope.newtask_keyup = function(evt){
        if(evt.keyCode == 13){
          m.addnew();
        }
    };

});