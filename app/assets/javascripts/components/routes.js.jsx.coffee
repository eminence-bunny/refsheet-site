{ @Router, @Redirect, @Switch, @Route, @Link } = ReactRouter


# Backfill for Router V4 not parsing query strings.
`const history = createBrowserHistory();
  function addLocationQuery(history){
  history.location = Object.assign(
      history.location,
      {
        query: qs.parse(history.location.search)
      }
  )
}

addLocationQuery(history);

history.listen(() => {
  addLocationQuery(history)
})`

@Routes = React.createClass
  propTypes:
    gaPropertyID: React.PropTypes.string
    eagerLoad: React.PropTypes.object
    flash: React.PropTypes.object

  componentDidMount: ->
    console.log "Loading #{@props.environment} environment."

    $ ->
      $('#rootAppLoader').fadeOut(300)

    if @props.gaPropertyID
      ReactGA.initialize(@props.gaPropertyID)

    if @props.flash
      for level, message of @props.flash
        color =
          switch level
            when 'error' then 'red'
            when 'warn' then 'yellow darken-1'
            when 'notice' then 'green'
            else 'grey darken-2'

        Materialize.toast message, 3000, color

  _handleRouteUpdate: ->
    if @props.gaPropertyID
      ReactGA.set page: window.location.pathname
      ReactGA.pageview window.location.pathname

    $(document).trigger 'navigate'

  render: ->
    if typeof Packs is 'undefined'
      console.log "Pack sync: Skipping render, JS v2 not loaded."
      return null

    staticPaths = ['privacy', 'terms', 'support'].map (path) ->
      `<Route key={ path } path={ '/' + path } component={ Static.View } />`

    router = `<Router history={ history } onUpdate={ this._handleRouteUpdate }>
      <Switch>
        <Route path='/' render={(props) =>
          <App {...props} eagerLoad={ this.props.eagerLoad } environment={ this.props.environment }>
            <Switch>
              <Route exact path='/' component={ Home } title='Home' />

              <Route path='/login' component={ LoginView } />
              <Route path='/register' component={ RegisterView } />

              <Route path='/account' title='Account' render={(props) =>
                <Views.Account.Layout {...props}>
                  <Switch>
                    <Redirect exact from='/account' to='/account/settings' />
                    <Route path='/account/settings' title='Account Settings' component={ Views.Account.Settings.Show } />
                    <Route path='/account/support' title='Support Settings' component={ Views.Account.Settings.Support } />
                    <Route path='/account/notifications' title='Notification Settings' component={ Views.Account.Settings.Notifications } />
                  </Switch>
                </Views.Account.Layout>
              } />

              <Route path='/moderate' component={ Packs.application.CharacterController } />

              <Route path='/notifications' title='Notifications' component={ Views.Account.Notifications.Show } />

              <Route path='/browse' component={ BrowseApp } />
              <Route path='/explore/:scope?' component={ Explore.Index } />


              <Route path='/forums'>
                <Switch>
                  <Route exact path='/forums' component={ Forums.Index } />

                  <Route path='/forums/:forumId' render={(props) =>
                    <Forums.Show {...props}>
                      <Route path='/forums/:forumId/:threadId' component={ Forums.Threads.Show } />
                    </Forums.Show>
                  }/>
                </Switch>
              </Route>


              {/*== Static Routes */}

              { staticPaths }
              <Route path='/static/:pageId' component={ Static.View } />


              {/*== Profile Content */}

              <Route path='/v2/:userId/:characterId' component={ Packs.application.CharacterController } />

              <Route path='/images/:imageId' component={ ImageApp } />
              <Route path='/:userId/:characterId' component={ CharacterApp } />
              <Route path='/:userId' component={ User.View } />

              {/*== Fallback */}

              <Route path='*' component={ NotFound } />
            </Switch>
          </App>}>
        </Route>
      </Switch>
    </Router>`

    `<Packs.application.V2Wrapper>{ router }</Packs.application.V2Wrapper>`
