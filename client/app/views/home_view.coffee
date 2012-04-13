Tree = require("./widgets/tree").Tree
NoteWidget = require("./note_view").NoteWidget
Note = require("../models/note").Note

# Main view that manages interaction between toolbar, navigation and notes
class exports.HomeView extends Backbone.View
    id: 'home-view'


    # Tree functions

    # Send a request for a tree modification.
    sendTreeRequest: (type, data, callback) ->
        $.ajax
            type: type
            url: "tree"
            data: data
            success: callback
            error: (data) ->
                if data and data.msg
                    alert data.msg
                else
                    alert "Server error occured."

    # Create a new folder inside currently selected node.
    createFolder: (path, data) =>
        @sendTreeRequest "POST",
            path: path
            name: data.rslt.name
            , (note) =>
                data.rslt.obj.data("id", note.id)
                data.inst.deselect_all()
                data.inst.select_node(data.rslt.obj)

    # Rename currently selected node.
    renameFolder: (path, newName) =>
        if newName?
            @sendTreeRequest "PUT",
                path: path
                newName: newName
        
    # Delete currently selected node.
    deleteFolder: (path) =>
        @noteArea.html null
        @sendTreeRequest "DELETE", path: path

    selectFolder: (path, id) =>
        if id?
            $.get "notes/#{id}", (data) =>
                note = new Note data
                @renderNote note
        else
            @noteArea.html null


    renderNote: (note) ->
        @noteArea.html null
        noteWidget = new NoteWidget note
        @noteArea.append noteWidget.render()

    # Initializers

    render: ->
        $(@el).html require('./templates/home')
        this

    # Fetch data loads notre tree and configure it.
    fetchData: ->
        @noteArea = $("#editor")
        $.get "tree/", (data) =>
            @tree = new Tree @.$("#nav"), data,
                onCreate: @createFolder
                onRename: @renameFolder
                onRemove: @deleteFolder
                onSelect: @selectFolder

