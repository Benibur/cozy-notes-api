exports.routes = (map) ->


    # routes for notes interactions
    map.get  '/notes-api-export/all'  , 'notes#all'
    map.get  '/notes-api-export/:id'  , 'notes#show'

