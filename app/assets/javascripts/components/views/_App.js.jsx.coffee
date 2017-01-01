@App = React.createClass
  getInitialState: ->
    currentUser: null,
    loading: true

  componentDidMount: ->
    $.get '/session', (data) =>
      @setState currentUser: data, loading: false

  signInUser: (user) ->
    @setState currentUser: user

  render: ->
    childrenWithProps = React.Children.map this.props.children, (child) =>
      React.cloneElement child,
        onLogin: @signInUser
        currentUser: @state.currentUser

    if @state.loading
      childrenWithProps = `<Loading />`

    `<div id='rootApp'>
        <UserBar currentUser={ this.state.currentUser } />
        { childrenWithProps }
        <Footer />
    </div>`
