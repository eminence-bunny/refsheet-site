@App = React.createClass
  childContextTypes:
    currentUser: React.PropTypes.object
    session: React.PropTypes.object
    setCurrentUser: React.PropTypes.func
    eagerLoad: React.PropTypes.object
    environment: React.PropTypes.string


  getInitialState: ->
    session: @props.route.eagerLoad?.session || { fetch: true }
    loading: 0
    eagerLoad: @props.route.eagerLoad || {}

  getChildContext: ->
    currentUser: @state.session.current_user
    session: @state.session
    setCurrentUser: @_onLogin
    eagerLoad: @state.eagerLoad
    environment: @props.route.environment


  componentWillMount: ->
    console.debug '[App] Mounting with eager loads:', @state.eagerLoad

    if @state.session.fetch
      Model.get '/session', (data) =>
        @setState session: data, loading: 0
        ReactGA.set userId: data.current_user?.id

  componentDidMount: ->
    @setState eagerLoad: null
    console.debug '[App] Mount complete, clearing eager load.'

    $(document)
      .on 'app:session:update', (e, session) =>
        @setState session: session
        ReactGA.set userId: session.current_user?.id

      .on 'app:loading', =>
        val = @state.loading + 1
        val = 1 if val <= 0
        @setState loading: val

      .on 'app:loading:done', =>
        val = @state.loading - 1
        val = 0 if val < 0
        @setState loading: val


  _onLogin: (user, callback) ->
    s = @state.session
    s.current_user = user
    @setState session: s, callback


  render: ->
    childrenWithProps = React.Children.map this.props.children, (child) =>
      React.cloneElement child,
        onLogin: @_onLogin
        currentUser: @state.currentUser


    `<div id='rootApp'>
        { this.state.loading > 0 &&
            <LoadingOverlay /> }

        <SessionModal />
        <Lightbox currentUser={ this.state.session.current_user } history={ this.props.history } />

        <UserBar session={ this.state.session } query={ this.props.location.query.q }/>

        { childrenWithProps }

        <Footer />

        <FeedbackModal name={ this.state.session.current_user && this.state.session.current_user.name } />
        <a className='btn modal-trigger feedback-btn' href='#feedback-modal'>Feedback</a>

        <NagBar action={{ href: 'https://patreon.com/refsheet', text: 'To Patreon!' }} type='neutral'>
            <div className='first-a-sincere-thank-you'>
                <strong>Hey, friend!</strong> &mdash; We've been making a lot of changes lately, and that's a good thing!
            </div>

            <div className='now-for-some-shameless-begging margin-top--small'>
                I can't make it happen without all your support. Thank you! In return, I'm giving all my supporters
                early access to new features as I develop them. Why not become a Patron?
            </div>
        </NagBar>
    </div>`
