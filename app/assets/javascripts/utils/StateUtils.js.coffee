@StateUtils =
  page: (context, path, page, props=context.props) ->
    page ||= (context.currentPage || 1) + 1

    console.debug '[StateUtils] Loading page: ' + page
    @fetch context, path, { page: page }, props


  load: (context, path, props=context.props, callback) ->
    { dataPath, paramMap } = context
    eagerLoad = context.context.eagerLoad
    state = $.extend {}, context.state
    fetch = true

    console.debug '[StateUtils] Loading with params:', props.params
    console.debug '[StateUtils] Eager Loading:', eagerLoad, context.context

    if elItem = ObjectPath.get eagerLoad, path
      for k, p of paramMap
        a = ObjectPath.get props.params, k
        b = ObjectPath.get elItem, p
        console.debug '[StateUtils] Comparing:', a, b
        fetch = false if a and b and a.toUpperCase() is b.toUpperCase()

      unless fetch
        console.debug '[StateUtils] Eager Loading:', elItem
        ObjectPath.set state, path, elItem
        context.setState state, ->
          callback(elItem) if callback

    if fetch
      @fetch context, path, {}, props, callback
      console.debug '[StateUtils] Scrolling up!'
      $(window).scrollTop 0


  fetch: (context, path, data={}, props=context.props, callback) ->
    fetchUrl = @getFetchUrl context, props
    state = $.extend {}, context.state

    Model.request 'GET', fetchUrl, data, (data) ->
      if data.$meta
        data = ObjectPath.get data, path

      ObjectPath.set state, path, data
      context.setState state, ->
        callback(data) if callback

    , (error) ->
      context.setState { error: error }, ->
        callback() if callback


  reload: (context, path, newProps, oldProps=context.props) ->
    fetch = false

    for k, p of context.paramMap
      a = ObjectPath.get oldProps.params, k
      b = ObjectPath.get newProps.params, k

      if (a or b) and a?.toUpperCase() isnt b?.toUpperCase()
        fetch = true
        break

    if fetch
      StateUtils.load context, path, newProps
      console.debug '[StateUtils] Scrolling up!'
      $(window).scrollTop 0


  poll: (context, path, props=context.props) ->
    #no-op


  updateItem: (context, path, item, primaryKey, callback) ->
    context.setState HashUtils.deepUpdateCollectionItem(context.state, path, item, primaryKey), callback

  updateItems: (context, path, items, primaryKey, callback) ->
    state = context.state

    items.map (item) ->
      state = HashUtils.deepUpdateCollectionItem(state, path, item, primaryKey)

    context.setState state, callback

  sortItem: (context, path, item, position, primaryKey, callback) ->
    context.setState HashUtils.deepSortCollectionItem(context.state, path, item, position, primaryKey), callback

  removeItem: (context, path, item, primaryKey, callback) ->
    context.setState HashUtils.deepRemoveCollectionItem(context.state, path, item, primaryKey), callback


  getFetchUrl: (stateLink, props) ->
    stateLink = stateLink() if typeof stateLink is 'function'
    { dataPath, paramMap } = stateLink

    fetchUrl = dataPath.replace /(:[a-zA-Z]+)/g, (m) ->
      param = ObjectPath.get props.params, m.substring(1)
      param || ''

    fetchUrl.replace /\/\/+|\/$/g, ''
