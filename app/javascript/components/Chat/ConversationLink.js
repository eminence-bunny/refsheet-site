import React from 'react'
import { format as n } from '../../utils/NumberUtils'
import c from 'classnames'
import Moment from 'moment'
import { gql } from 'apollo-client-preset/lib/index'
import { Subscription } from 'react-apollo'

const ConversationLink = ({ subscriptionData, conversation, onClick }) => {
  const data = subscriptionData.data || {}

  const {
    guid,
    unreadCount,
    lastMessage,
    user
  } = (data.conversationChanged || conversation)

  const isUnread = unreadCount > 0

  const handleClick = (e) => {
    e.preventDefault()
    onClick({id: guid})
  }

  const usernameDisplay = `@${user.username}`

  const timeDisplay = (full=false) => {
    const m = Moment.unix(lastMessage.created_at)
    if (full) {
      return m.format('llll')
    } else if (m.isSame(Moment(), 'day')) {
      return m.format('h:mm A')
    } else if(m.isSame(Moment(), 'week')) {
      return m.format('ddd')
    } else {
      return m.format('l')
    }
  }

  return (<li className={ c('chat-conversation', { unread: isUnread }) }>
    <a href='#' onClick={ handleClick }>
      <img src={ user.avatar_url }
           alt={ usernameDisplay }
           title={ usernameDisplay}
      />
      <div className='time' title={timeDisplay(true)}>{ timeDisplay() }</div>
      <div className='title'>
        <span title={usernameDisplay}>{ user.name }</span>
        { isUnread && <span className='unread-count'>({ n(unreadCount) })</span> }
      </div>
      <div className='last-message'>{ lastMessage.message }</div>
    </a>
  </li>)
}

const CONVERSATION_SUBSCRIPTION = gql`
    subscription conversationChanged($conversationId: ID!) {
        convChanged(convId: $conversationId) {
            id
            unreadCount
            lastMessage {
                message
                created_at
            }
            user {
                name
                username
                avatar_url
            }
        }
    }
`

const Wrapped = (props) => (
  <Subscription subscription={CONVERSATION_SUBSCRIPTION} variables={{conversationId: props.conversation.guid}}>
    {(subscriptionData) => (<ConversationLink {...props} subscriptionData={subscriptionData} />)}
  </Subscription>
)

export default Wrapped