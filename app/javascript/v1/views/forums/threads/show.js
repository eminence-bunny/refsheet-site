/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import RichText from '../../../../components/Shared/RichText'
import Main from 'v1/shared/Main'
import LegacyForumReply from '../../../../components/Forums/LegacyForumReply'
import IdentityLink from 'v1/shared/identity_link'
import IdentityAvatar from 'v1/shared/identity_avatar'
import StateUtils from '../../../utils/StateUtils'
import Model from '../../../utils/Model'
import HashUtils from '../../../utils/HashUtils'
import Loading from '../../../../components/Shared/views/Loading'
import compose, { withCurrentUser } from '../../../../utils/compose'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Show = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
  },

  propTypes: {
    onReply: PropTypes.func,
  },

  dataPath: '/forums/:forumId/:threadId',

  poller: null,

  paramMap: {
    forumId: 'forum_id',
    threadId: 'id',
  },

  getInitialState() {
    return { thread: null }
  },

  componentDidMount() {
    StateUtils.load(this, 'thread', this.props, thread => {
      if (thread) {
        this._poll()
      }
      return console.log('Starting poll.')
    })
  },

  componentWillUnmount() {
    clearTimeout(this.poller)
    return console.log('Stopping poll.')
  },

  _poll() {
    return (this.poller = setTimeout(() => {
      return Model.poll(this.state.thread.path, {}, data => {
        if (data.id === this.state.thread.id) {
          const willScroll =
            this.state.thread.posts.length < data.posts.length &&
            window.innerHeight + window.scrollY >= document.body.offsetHeight

          this.setState({ thread: data }, () => {
            if (willScroll) {
              return window.scrollTo(
                0,
                document.getElementById('scroll-to-here').offsetTop
              )
            }
          })
        }

        return this._poll()
      })
    }, 3000))
  },

  componentDidUpdate(prevProps) {
    if (
      !HashUtils.compare(
        prevProps.match.params,
        this.props.match.params,
        'forumId',
        'threadId'
      )
    ) {
      StateUtils.reload(this, 'thread', this.props, prevProps)
    }
  },

  _handleReply(post) {
    StateUtils.updateItem(this, 'thread.posts', post, 'id', () =>
      window.scrollTo(0, document.getElementById('scroll-to-here').offsetTop)
    )
    if (this.props.onReply) {
      return this.props.onReply(post)
    }
  },

  render() {
    if (!this.state.thread) {
      return <Loading />
    }

    const posts = this.state.thread.posts.map(post => (
      <div className="card sp with-avatar" key={post.id}>
        <IdentityAvatar
          src={post.user}
          avatarUrl={
            post.character &&
            (post.character.profile_image_url ||
              (post.character.profile_image &&
                post.character.profile_image.url.thumbnail))
          }
          name={post.character && post.character.name}
        />

        <div className="card-content">
          <div className="muted right">{post.created_at_human}</div>
          <IdentityLink
            to={post.user}
            name={post.character && post.character.name}
            link={post.character && post.character.link}
            avatarUrl={
              post.character &&
              (post.character.profile_image_url ||
                (post.character.profile_image &&
                  post.character.profile_image.url.thumbnail))
            }
          />
          <RichText
            className="margin-top--small"
            contentHtml={post.content_html}
            content={post.content}
          />
        </div>
      </div>
    ))

    return (
      <Main title={this.state.thread.topic}>
        <div className="card margin-top--none sp with-avatar">
          <IdentityAvatar src={this.state.thread.user} />

          <div className="card-content">
            <div className="right muted right-align">
              {this.state.thread.created_at_human}
            </div>

            <div className="author">
              <IdentityLink to={this.state.thread.user} />
              <div className="muted">
                @{this.state.thread.user.username}{' '}
                {this.state.thread.user.is_admin && <span>&bull; Admin</span>}
              </div>
            </div>
          </div>

          <div className="card-header">
            <h2 className="title">{this.state.thread.topic}</h2>
            <RichText
              content={this.state.thread.content}
              contentHtml={this.state.thread.content_html}
            />
          </div>
        </div>

        {posts}

        <div id="scroll-to-here" />

        {this.props.currentUser && (
          <LegacyForumReply
            discussionId={this.state.thread.guid}
            onPost={this._handleReply}
          />
        )}
      </Main>
    )
  },
})

export default compose(withCurrentUser())(Show)
