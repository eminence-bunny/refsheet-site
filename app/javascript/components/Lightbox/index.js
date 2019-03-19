import React, { Component } from 'react'
import {closeLightbox, openLightbox} from "../../actions";
import {connect} from "react-redux";
import {Icon} from 'react-materialize';
import {Query} from "react-apollo";
import getMedia from './getMedia.graphql'
import View from "./View";
import Silhouette from "./Silhouette";
import {Error, Loading} from "./Status";

class Lightbox extends Component {
  constructor(props) {
    super(props)

    this.handleKeyDown = this.handleKeyDown.bind(this)
  }

  handleCloseClick(e) {
    e.preventDefault()
    this.props.closeLightbox()
  }

  handleWrapperClick(e) {
    e.preventDefault()
    if (e.target.id !== 'lightbox-wrapper') {
      return
    }

    this.props.closeLightbox()
  }

  handleMediaOpen(mediaId) {
    this.props.openLightbox(mediaId, this.props.gallery)
  }

  handleKeyDown(e) {
    switch(e.keyCode) {
      case 27: // ESC
      case 81: // q
        this.props.closeLightbox()
        break

      case 80: // p
      case 37: // <-
      case 188: // ,
        this.prev()
        break

      case 78: // n
      case 39: // ->
      case 190: // .
        this.next()
        break

      case 70:
        // f
        break

      case 67:
        // c - comment
    }
  }

  componentWillMount() {
    document.body.classList.add('lightbox-open')
    document.addEventListener("keydown", this.handleKeyDown)
  }

  componentWillUnmount() {
    document.body.classList.remove('lightbox-open')
    document.removeEventListener("keydown", this.handleKeyDown)
  }

  getGalleryIndex() {
    const {
      mediaId,
      gallery
    } = this.props

    return gallery.indexOf(mediaId)
  }

  getNextMediaId() {
    const {
      gallery
    } = this.props

    const index = this.getGalleryIndex()
    if (index < 0 || gallery.length <= 1) {
      return null
    }

    if (index >= gallery.length - 1) {
      return gallery[0]
    }

    return gallery[index + 1]
  }

  getPrevMediaId() {
    const {
      gallery
    } = this.props

    const index = this.getGalleryIndex()
    if (index < 0 || gallery.length <= 1) {
      return null
    }

    if (index === 0) {
      return gallery[gallery.length - 1]
    }

    return gallery[index - 1]
  }

  prev() {
    const mediaId = this.getPrevMediaId()
    if (typeof mediaId !== 'undefined' && mediaId !== null) {
      this.props.openLightbox(mediaId, this.props.gallery)
    }
  }

  next() {
    const mediaId = this.getNextMediaId()
    if (typeof mediaId !== 'undefined' && mediaId !== null) {
      this.props.openLightbox(mediaId, this.props.gallery)
    }
  }

  renderContent() {
    const {
      data,
      loading,
      error
    } = this.props

    if (loading) {
      return (
        <Silhouette>
          <Loading />
        </Silhouette>
      )
    }

    if (error || !data || !data.getMedia) {
      return (
        <Silhouette>
          <Error error={error} />
        </Silhouette>
      )
    }

    return <View
      {...data.getMedia}
      nextMediaId={this.getNextMediaId()}
      prevMediaId={this.getPrevMediaId()}
      onMediaOpen={this.handleMediaOpen.bind(this)}
    />
  }

  render() {
    return (
      <div
        className={'lightbox-wrapper v2'}
        id={'lightbox-wrapper'}
        onClick={this.handleWrapperClick.bind(this)}
        onKeyDown={this.handleKeyDown.bind(this)}
      >
        <div className={'lightbox v2'}>
          <a className={'close'} role={'button'} href={'#'} onClick={this.handleCloseClick.bind(this)}>
            <Icon>close</Icon>
          </a>

          { this.renderContent() }
        </div>
      </div>
    )
  }
}

const Wrapped = (props) => {
  const {
    mediaId
  } = props

  if (mediaId === null) {
    return null
  }

  return <Query query={getMedia} variables={{mediaId}}>
    {({data, loading, error}) => <Lightbox {...props} data={data} loading={loading} error={error} />}
  </Query>
}

const mapStateToProps = ({lightbox}) => ({
  mediaId: lightbox.mediaId,
  gallery: lightbox.gallery
})

const mapDispatchToProps = {
  openLightbox,
  closeLightbox
}

export default connect(mapStateToProps, mapDispatchToProps)(Wrapped)