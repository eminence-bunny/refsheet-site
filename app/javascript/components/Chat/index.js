import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { gql } from 'apollo-client-preset'
import { Icon } from 'react-materialize'
import Conversations from './Conversations'
import Conversation from './Conversation'
import c from 'classnames'
import { format as f } from 'NumberUtils'
import { Query, Subscription } from 'react-apollo'

class Chat extends Component {
  constructor(props) {
    super(props)

    this.state = {
      isOpen: false,
      activeConversationId: null
    }

    this.handleOpenClose = this.handleOpenClose.bind(this)
    this.handleConversationChange = this.handleConversationChange.bind(this)
  }

  handleOpenClose(e) {
    e.preventDefault()
    this.setState({isOpen: !this.state.isOpen})
  }

  handleConversationChange({id}) {
    let activeConversationId = null

    if(typeof id !== 'undefined' && id !== null) {
      activeConversationId = id
    }

    this.setState({activeConversationId})
  }

  render() {
    const {
        isOpen,
        activeConversationId
    } = this.state

    const {
        unread
    } = this.props

    let title, body, isUnread

    if(unread) {
      title = `Conversations (${f(unread)} new)`
      isUnread = true
    } else {
      title = 'Conversations'
    }

    if(activeConversationId !== null) {
      body = <Conversation key={activeConversationId} id={activeConversationId} onClose={this.handleConversationChange} />
    } else {
      body = <Conversations onConversationSelect={this.handleConversationChange} />
    }

    return (<div className={c('chat-popout', {open: isOpen, unread: isUnread})}>
      <div className='chat-title'>
        <a href='#' className='right white-text' onClick={this.handleOpenClose}>
          <Icon>{ isOpen ? 'keyboard_arrow_down' : 'keyboard_arrow_up' }</Icon>
        </a>
        <a href='#' className='white-text' onClick={this.handleOpenClose}>
          { title }
        </a>
      </div>

      { isOpen && body }
    </div>)
  }
}

const CHAT_COUNT_SUBSCRIPTION = gql`
    subscription chatCountsChanged {
        chatCountsChanged {
            unread
        }
    }
`

const CHAT_COUNT_QUERY = gql`
    query chatCounts {
        chatCounts {
            unread
        }
    }
`

const Wrapped = (props) => {
  return <Subscription subscription={CHAT_COUNT_SUBSCRIPTION}>
    {({data: subscriptionData}) =>
        <Query query={CHAT_COUNT_QUERY}>
          {({data: queryData}) => {
            const counts = (
                (queryData && queryData.chatCounts) ||
                (subscriptionData && subscriptionData.chatCountsChanged) ||
                { unread: 0 }
            )

            return <Chat {...props} unread={counts.unread} />
          }}
        </Query>}
  </Subscription>
}

Chat.propTypes = {
  unread: PropTypes.number
}

export default Wrapped
