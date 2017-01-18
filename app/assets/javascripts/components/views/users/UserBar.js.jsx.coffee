@UserBar = React.createClass
  componentDidMount: ->
    $('.user-bar .tooltipped').tooltip()

  render: ->
    if @props.currentUser?
      currentUser =
        `<ul className='right'>
            {/*<li>
                <Link to='/messages' activeClassName='teal-text text-lighten-2'>
                    <i className='material-icons'>message</i>
                </Link>
            </li>*/}

            <li>
                <Link to={ '/' + this.props.currentUser.username } className='avatar tooltipped' data-tooltip='Your Profile' data-position='left'>
                    <img src={ this.props.currentUser.avatar_url } className='circle' />
                </Link>
            </li>
        </ul>`

    else
      currentUser =
        `<ul className='right'>
            <li>
                <Link to='/register' activeClassName='teal-text text-lighten-2'>Sign Up</Link>
            </li>
            <li>
                <Link to='/login' activeClassName='teal-text text-lighten-2'>Log In</Link>
            </li>
        </ul>`

    `<div className='navbar-fixed user-bar'>
        <nav>
          <div className='container'>
              <Link to='/' className='logo left'>
                  Refsheet.net
                  {/*<img src='https://placehold.it/144x50' />*/}
              </Link>

              <ul className='hide-on-small-and-down'>
                  <li>
                      <Link to='/browse' activeClassName='teal-text text-lighten-2'>Browse</Link>
                  </li>
                  {/*<li>
                      <Link to='/guilds' activeClassName='teal-text text-lighten-2'>Guilds</Link>
                  </li>
                  <li>
                      <Link to='/search' activeClassName='teal-text text-lighten-2'>Search</Link>
                  </li>*/}
              </ul>

              { currentUser }
          </div>
        </nav>
    </div>`
