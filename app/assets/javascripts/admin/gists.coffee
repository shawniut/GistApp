# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


class GistFile
  constructor: (file={})->
    @id                         = ko.observable(if file.id? then file.id)
    @deleted                    = ko.observable(if file.deleted? then file.deleted)
    @filename                   = ko.observable(if file.filename? then file.filename)
    @old_filename               = ko.observable(if file.old_filename? then file.old_filename)
    @content                    = ko.observable(if file.content? then file.content)

class History
  constructor: (history={})->
    @version                       = history.version
    @committed_at_display          = history.committed_at_display
    @deletions                     = history.deletions
    @additions                     = history.additions
    @total                         = history.total

class Gist
  constructor: (gist={})->
    @id                         = ko.observable(if gist.id? then gist.id)
    @description                = ko.observable(if gist.description? then gist.description)
    @files                      = ko.observableArray([])
    @histories                  = ko.observableArray([])

    if typeof gist.files != 'undefined'
      gist.files.forEach (file)=>
        @files.push(new GistFile(file))
    if typeof gist.histories != 'undefined'
      gist.histories.forEach (history)=>
        @histories.push(new History(history))


class GistIndexVM
  constructor: ->
    @isLoading = ko.observableArray([])
    @gists = ko.observableArray([])
    @stared = ko.observable(false)

    @pager = ko.observable(new PagingVM(
      pageSize: 10   
      totalCount: 0))

    @pager().CurrentPage.subscribe (newPage) =>
      @fetchItems()

    @toggleStarred = =>
      @stared(!@stared())
      @fetchItems()

    @ajaxUrl = =>
      url = ''
      url += '/admin/gists/search?page='+ @pager().CurrentPage() + '&per_page=' + @pager().PageSize()
      url += "&stared=" + @stared() if @stared() == true
      url

    @deleteGist = (gist)=>
      if confirm("Are you sure you want to delete the gist?")
        @isLoading(true)
        $.ajax
          type: 'DELETE'
          dataType: 'json'
          url:  "/admin/gists/#{gist.id()}"
          error: (jqXHR, textStatus, errorThrown) =>
            toastr['error']('An error has been occurred! Please try again.')
          success: (result, textStatus, jqXHR) =>
            if result.success
              toastr['success']('Gist deleted successfully')
              @fetchItems()
            else
              toastr['error']('Error deleting gist')
        .always =>
          @isLoading(false)

    @fetchItems = =>
      $.ajax @ajaxUrl(),
        type: 'GET'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) =>
            toastr['error']('Error loading gists! Please try again.')
        success: (result, textStatus, jqXHR) =>
          ko.mapping.fromJS(result.gists,{},@gists)
          @pager().Update
            TotalCount: result.meta.total_count,
            PageSize: @pager().PageSize(),
            CurrentPage: result.meta.current_page
      .always =>
        @isLoading(false)
    @fetchItems()

$(document).ready ->
  if $("#gists-index").length > 0
    ko.applyBindings new GistIndexVM(), document.getElementById("brand-index")


class GistCreateEditVM
  constructor: ->
    @isLoading  = ko.observable(false)
    @isEdit     = ko.observable($('#gist_data').data('is-edit'))
    @gist       = ko.observable(new Gist({files:[{}]}))

    if @isEdit()
      @gist(new Gist($('#gist_data').data('gist')))

    @showHistory = =>
      $('#historyModal').modal('show')

    @addFileClick = =>
      @gist().files.push(new GistFile())

    @removeFile = (file) =>
      if confirm('Are you sure you want to remove the file?')
        if @isEdit()
          file.deleted(true)
          file.content(null)
        else
          @gist().files.remove(file)

    @setupValidations = =>
      rules = {
        description:
          required: true
      }

      @gist().files().forEach (item,index)=>
        rules["filename[#{index}]"] = {required:true}
        rules["content[#{index}]"] = {required:true}

      $('#gist_form').data('validator', null);
      $('#gist_form').validate
          rules:rules

    @allGist = =>
      window.location = "/admin/gists/"

    @createGist = =>
      @setupValidations()
      if $('#gist_form').valid()
        @isLoading(true)
        $.ajax
          type: 'POST'
          dataType: 'json'
          data: {gist: ko.toJS(@gist())}
          url:  '/admin/gists'
          error: (jqXHR, textStatus, errorThrown) =>
            toastr['error']('An error has been occurred! Please try again.')
          success: (result, textStatus, jqXHR) =>
            if result.success
              toastr['success']('Gist created successfully')
              window.location = "/admin/gists/"+result.id+'/edit'
            else
              toastr['error']('Error adding the new secret gist')
        .always =>
          @isLoading(false)
      else
        toastr['info']('Please fix the incorect inputs.')

    @updateGist = =>
      @setupValidations()
      if $('#gist_form').valid()
        @isLoading(true)
        $.ajax
          type: 'PATCH'
          dataType: 'json'
          data: {gist: ko.toJS(@gist())}
          url:  "/admin/gists/#{@gist().id()}"
          error: (jqXHR, textStatus, errorThrown) =>
            toastr['error']('An error has been occurred! Please try again.')
          success: (result, textStatus, jqXHR) =>
            if result.success
              toastr['success']('Gist Updated successfully')
            else
              toastr['error']('Error updating gist')
        .always =>
          @isLoading(false)
      else
        toastr['info']('Please fix the incorect inputs.')

    @deleteGist = =>
      if confirm("Are you sure you want to delete the gist?")
        @isLoading(true)
        $.ajax
          type: 'DELETE'
          dataType: 'json'
          url:  "/admin/gists/#{@gist().id()}"
          error: (jqXHR, textStatus, errorThrown) =>
            toastr['error']('An error has been occurred! Please try again.')
          success: (result, textStatus, jqXHR) =>
            if result.success
              toastr['success']('Gist deleted successfully')
              window.location = "/admin/gists"
            else
              toastr['error']('Error deleting gist')
        .always =>
          @isLoading(false)

$(document).ready ->
  if $("#gists_create_edit").length > 0
    ko.applyBindings new GistCreateEditVM(), document.getElementById("brand-index")





