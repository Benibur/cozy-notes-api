exports.routes = (map) ->


    # routes for notes interactions
    map.get  '/all'  , 'notes#all'
    map.get  '/:id'  , 'notes#show'

