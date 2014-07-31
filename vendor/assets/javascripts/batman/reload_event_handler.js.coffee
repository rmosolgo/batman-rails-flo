handleLiveReloadEvent = (ev) ->
  try
    code = ev.data.contents
    filePath = ev.data.url
    isHTML = code.substr(0,6) is "HTML>>"
    isCSS = filePath.indexOf('.css') > -1

    fileClassName = filePath.replace(/^.*\/(.*)\.js/, "$1")
    className = Batman.helpers.camelize(fileClassName)
    appClass = Batman.currentApp[className]

    if isHTML
      htmlPath = code.substr(6)
      console.debug "HTML Reload: #{htmlPath}"
      Batman.View.liveReloadHTML()

    else if isCSS
      cssPath = filePath.substr(6)
      console.debug "CSS Reload: #{cssPath}"
      queryString = '?reload=' + new Date().getTime();
      found = false
      # search all stylesheets for the one that got reloaded
      $('link[rel="stylesheet"]').each ->
        if this.href.indexOf(cssPath) > -1
          found = this

      if found # then force reload by updating href
        found.href = found.href.replace(/\?.*|$/, queryString)
      else
        console.warn("NO CSS FOUND FOR #{cssPath}")

    # Classes can implement .liveReload hooks
    else if appClass?.liveReload
      console.debug "#{className} Reload: #{ev.data.url}"
      appClass.liveReload?(className, code)
      Batman.currentApp.liveReloadClass(className)

    # handle a plain-js class by just eval'ing the code
    # (for example, if you have some plain-coffeescript classes in your app)
    else if appClass? && !appClass.__super__?
      console.debug "Plain JS Reload: #{className} with #{ev.data.url}"
      eval(code)

    else
      console.warn "Couldn't reload #{filePath}."

    # you can hook your own handler up to it if you want
    Batman.currentApp.fire("liveReload", ev)

  catch err
    console.warn "handleLiveReloadEvent Error: #{err}", err

if !window._batmanLiveReload
  window.addEventListener('fb-flo-reload', handleLiveReloadEvent)
  window._batmanLiveReload = true # only attach the listener once, just in case