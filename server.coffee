#!/usr/bin/env coffee


###*
 * Hack for modifying /config/database.json for CloudFoundry
###

fs = require('fs')
path1 = "./config/database.json.template"
path2 = "./config/database.json"
console.log "toto"

# Open the template
fs.readFile path1, 'ascii', (err,data) ->
    if err
        console.error("Could not open file: %s", err)
        process.exit(1)

    # prepare the mongo url
    if process.env.VCAP_SERVICES
        env      = JSON.parse(process.env.VCAP_SERVICES)
        mongo    = env['mongodb-2.0'][0]['credentials']
        mongourl = "mongodb://" + mongo.hostname + ":" + mongo.port + "/" + mongo.db
    else
        mongourl = "mongodb://127.0.0.1/cozy-home"

        # replace in the template "mongourl" by the correct value
        myregex    = /mongourl/g
        mongoconf  = data.replace myregex, mongourl
        console.log "database.json prepared before starting the server :"
        console.log mongoconf

        # save file
        fs.writeFile path2, mongoconf, (err)->
            if (err) 
                throw err
            else
                
                ###*
                 * Standard init of the server
                ###

                app = module.exports = require('railway').createServer()

                if not module.parent
                    port = process.env.PORT or 8001
                    app.listen port
                    console.log "Railway server listening on port %d within %s environment", port, app.settings.env
        



