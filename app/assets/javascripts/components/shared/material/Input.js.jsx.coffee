@Input = React.createClass
  handleChange: (e) ->
    @props.onChange e.target.id, e.target.value
    e.preventDefault()

  render: ->
    if @props.error?
      className = 'invalid'

    `<div className='input-field'>
        <input type={ this.props.type || 'text' }
               id={ this.props.id }
               name={ this.props.id }
               placeholder={ this.props.placeholder }
               value={ this.props.value || ''}
               onChange={ this.handleChange }
               autoFocus={ this.props.autoFocus }
               className={ className } />

        <label htmlFor={ this.props.id } data-error={ this.props.error }>{ this.props.label }</label>
    </div>`
