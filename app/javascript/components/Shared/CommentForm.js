import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import IdentitySelect from './CommentForm/IdentitySelect'
import UserAvatar from '../User/UserAvatar'
import IdentityModal from './CommentForm/IdentityModal'
import Restrict from './Restrict'
import MarkdownEditor from './MarkdownEditor'
import { Row, Col, Button } from 'react-materialize'

// TODO: This class has now 3 different styles that it produces,
//       this should be refactored into a generic wrapper that handles
//       functionality and passes components to a child class to render
//       those specific variants.
//
// Known Variants:
//   - default (V1 Forums, Status Updates)
//   - slim    (Lightbox Comment Form, Messages?)
//   - v2Style (V2 Forums)
//
class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: '',
      error: '',
      identityModalOpen: false,
      submitting: false,
    }
  }

  handleCommentChange(name, comment) {
    this.setState({ comment })
  }

  handleIdentityOpen() {
    this.setState({ identityModalOpen: true })
  }

  handleIdentityClose() {
    this.setState({ identityModalOpen: false })
  }

  handleError(error) {
    console.error(error)
    let message = ''

    if (error.map) {
      message = error.map(e => e.message).join(', ')
    } else {
      message = error.message || '' + error
    }

    this.setState({ submitting: false, error: message })
  }

  handleSubmit(e) {
    e.preventDefault()
    this.setState({ submitting: true })

    if (!this.state.comment) {
      M.toast({
        html: 'Please enter a comment!',
        displayLength: 3000,
        classes: 'red',
      })
    }

    this.props
      .onSubmit({
        comment: this.state.comment,
        identity: this.props.identity,
      })
      .then(data => {
        if (data && data.errors) {
          this.handleError(data.errors[0])
        } else {
          this.setState({ comment: '', submitting: false, error: '' })

          if (this.props.onSubmitConfirm) {
            this.props.onSubmitConfirm(data.data || data)
          }
        }
      })
      .catch(this.handleError.bind(this))
  }

  render() {
    const {
      inCharacter = false,
      identity,
      richText,
      slim = false,
      emoji,
      hashtags,
    } = this.props

    const placeholder = (this.props.placeholder || '').replace(
      /%n/,
      identity.name
    )

    let submitButton, input

    if (slim) {
      submitButton = (
        <div className={'send'}>
          <Button
            type={'submit'}
            className={'btn right flat'}
            disabled={!this.state.comment || this.state.submitting}
          >
            {this.state.submitting ? (
              <Icon title={this.props.buttonSubmittingText}>
                hourglass_empty
              </Icon>
            ) : (
              <Icon title={this.props.buttonText}>send</Icon>
            )}
          </Button>
        </div>
      )

      input = (
        <Input
          type={'text'}
          name={'comment'}
          browserDefault
          noMargin
          disabled={this.state.submitting}
          placeholder={placeholder}
          value={this.state.comment}
          onChange={this.handleCommentChange.bind(this)}
        />
      )
    } else {
      submitButton = (
        <Row className={'no-margin'}>
          <Col s={8}>
            <Restrict patron>
              {inCharacter && (
                <IdentitySelect
                  onClick={this.handleIdentityOpen.bind(this)}
                  name={identity.name}
                />
              )}
            </Restrict>
          </Col>
          <Col s={4}>
            <Button
              type={'submit'}
              onClick={this.handleSubmit.bind(this)}
              className="btn right"
              disabled={!this.state.comment || this.state.submitting}
            >
              {this.state.submitting
                ? this.props.buttonSubmittingText
                : this.props.buttonText}
            </Button>
          </Col>
        </Row>
      )

      if (richText) {
        input = (
          <MarkdownEditor
            name={'comment'}
            readOnly={this.state.submitting}
            placeholder={placeholder}
            content={this.state.comment}
            emoji={emoji}
            hashtags={hashtags}
            onChange={this.handleCommentChange.bind(this)}
          />
        )
      } else {
        input = (
          <Input
            type={'textarea'}
            name="comment"
            browserDefault
            noMargin
            disabled={this.state.submitting}
            placeholder={placeholder}
            value={this.state.comment}
            onChange={this.handleCommentChange.bind(this)}
          />
        )
      }
    }

    if (this.props.v2Style) {
      return (
        <div className={'v2-reply-box'}>
          <UserAvatar
            user={this.props.currentUser}
            identity={identity}
            onIdentityChangeClick={this.handleIdentityOpen.bind(this)}
          />

          <div className={'reply-content card sp'}>
            <div className={'reply-content card-content padding--none'}>
              {input}
            </div>

            {this.state.error && (
              <div className={'error card-footer red-text smaller'}>
                {this.state.error}
              </div>
            )}

            <div className={'card-footer'}>{submitButton}</div>

            {this.state.identityModalOpen && (
              <IdentityModal onClose={this.handleIdentityClose.bind(this)} />
            )}
          </div>
        </div>
      )
    }

    return (
      <div className={'comment-form'}>
        <form
          className={c('card margin-top--none sp with-avatar')}
          onSubmit={this.handleSubmit.bind(this)}
        >
          <UserAvatar
            user={this.props.currentUser}
            identity={identity}
            onIdentityChangeClick={this.handleIdentityOpen.bind(this)}
          />

          <div className="card-content reply-box">
            {input}
            {this.state.error && (
              <span className={'error red-text smaller'}>
                {this.state.error}
              </span>
            )}
            {submitButton}
          </div>
        </form>

        {this.state.identityModalOpen && (
          <IdentityModal onClose={this.handleIdentityClose.bind(this)} />
        )}
      </div>
    )
  }
}

CommentForm.propTypes = {
  inCharacter: PropTypes.bool,
  richText: PropTypes.bool,
  onSubmit: PropTypes.func.isRequired,
  onSubmitConfirm: PropTypes.func,
  placeholder: PropTypes.string,
  value: PropTypes.string,
  buttonText: PropTypes.string,
  buttonSubmittingText: PropTypes.string,
  slim: PropTypes.bool,
  hashtags: PropTypes.bool,
  emoji: PropTypes.bool,
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
  identity: state.session.identity,
})

export default connect(mapStateToProps)(CommentForm)
