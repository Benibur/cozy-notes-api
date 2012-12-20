exports.routes = (map) ->


    map.get  '/'          , 'notes#index'
    
    # routes for notes interactions
    map.get  '/all'  , 'notes#all'
    map.get  '/:id'  , 'notes#show'

