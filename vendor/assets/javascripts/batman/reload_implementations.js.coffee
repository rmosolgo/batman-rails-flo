
# Force batman.js to look up & calculate accessors again.
Batman.Object::liveReload = (newConstructor) ->
  throw "You must pass a constructor to liveReload" unless newConstructor?
  @_batman._allAncestors = false # force recalculation
  @__proto__ = newConstructor.prototype
  @constructor = newConstructor
  Batman.initializeObject(@)
  @refreshProperties()


Batman.Object::refreshProperties = ->
  @_batman.properties.forEach (name, property) ->
    if property instanceof Batman.Keypath
      property.terminalProperty().refresh()
    property.refresh()

###
This will force reload of class accessors that are rendered in views.
###

Batman.App.liveReloadClass = (className) ->
  re = new RegExp(className)
  @_batman.properties.forEach (name, property) ->
    if name.match(re)
      property.refresh()

###
For app classes, `.liveReload` has to:

- Identify existing instances of the class
- Load the new class
- Live-reload existing instances with the new class
- Attach those existing instances to the new constructor (so they'll be found again next time)
###

Batman.Model.liveReload = (className, newCode) ->
  existing = @get('loaded')
  eval(newCode)
  newClass = Batman.currentApp[className]
  existing.forEach (record) ->
    record.liveReload(newClass)
  newClass.set('loaded', existing)

Batman.Controller.liveReload = (className, newCode) ->
  instance = @get('_sharedController')
  eval(newCode)
  return unless instance # it's possible it hasn't been instantiated yet
  newClass = Batman.currentApp[className]
  instance.liveReload(newClass)
  newClass.set("_sharedController", instance)
  instance.get('currentView')?.refreshProperties()
  route = App.get('currentRoute')
  params = App.get('currentParams').toObject()
  route.dispatch(params)

Batman.View.refreshProperties = ->
  Batman.Object::refreshProperties.call(@)
  @subviews?.forEach (sv) ->
    sv.refreshProperties(sv)

Batman.View.liveReload = (className, newCode) ->
  currentViews = @_currentViews
  eval(newCode)
  newClass = Batman.currentApp[className]
  currentViews?.forEach (view) ->
    view.liveReload(newClass)
  newClass._currentViews = currentViews

# Track view instances so that they can be reloaded
Batman.View::on 'viewDidAppear', ->
  @constructor._currentViews ||= new Batman.SimpleSet
  @constructor._currentViews.add(@)

Batman.View::on 'viewWillDisappearAppear', ->
  @constructor._currentViews.remove(@)

# Out of the box, HTMLStore's default accessor is _final_,
# meaning it can't change after the first `set`.
# Let's undo that:
storeAccessor = Batman.HTMLStore::_batman.getFirst('defaultAccessor')
storeAccessor.final = false

# And define an unset operation:
storeAccessor.unset = (path) ->
  if !path.charAt(0) is "/"
    path = "/#{path}"
  @_requestedPaths.remove(path)
  @_htmlContents[path] = undefined

# Climbs the view tree, looking for one that has a source
Batman.View::superviewWithSource = ->
  if @get('source')?
    return @
  else
    return @?superview.superviewWithSource()

# Refresh HTML by finding the next view with a source
# and refreshing subviews
Batman.View::refreshHTML = (stack=[])->
  @sourceView ?= @superviewWithSource()
  if @sourceView?
    @_refreshSourceView(stack)
  if @subviews?.length
    @_refreshSubviews()

Batman.View::_refreshSourceView = (stack) ->
  @sourceView.html = undefined
  path = @sourceView.get('source')
  if path.charAt(0) isnt "/"
    path = "/#{path}"
  return if path in stack
  stack.push(path)
  Batman.View.store.unset(path)
  Batman.View.store.observeOnce path, (nv, ov) =>
    @sourceView.set('html', nv)
    @sourceView.loadView()
    @sourceView.initializeBindings()

Batman.View::_refreshSubviews = ->
  @subviews?.forEach (sv) ->
    if sv.get('source')?
      sv.refreshHTML()
    if sv.subviews?.length
      sv._refreshSubviews()

Batman.View.liveReloadHTML = ->
  # Refresh all HTML, going down from `layout`
  Batman.currentApp.get('layout').refreshHTML([])