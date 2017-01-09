@AttributeTable = React.createClass
  getInitialState: ->
    activeEditor: @props.activeEditor

  clearEditor: ->
    @setState activeEditor: null

  componentDidMount: ->
    if @props.onAttributeUpdate?
      $('.attribute-table.sortable').sortable
        items: 'li:not(.attribute-form)'
        placeholder: 'drop-target'
        forcePlaceholderSize: true
        stop: (_, el) =>
          $item = $(el.item[0])
          position = $item.parent().children().index($item)

          @props.onAttributeUpdate
            id: $item.data 'attribute-id'
            rowOrderPosition: position

  render: ->
    children = React.Children.map @props.children, (child) =>
      React.cloneElement child,
        onCommit: @props.onAttributeUpdate
        onDelete: @props.onAttributeDelete
        editorActive: (@state.activeEditor == child.key)
        sortable: @props.sortable
        valueType: @props.valueType
        defaultValue: @props.defaultValue
        freezeName: @props.freezeName
        hideNotesForm: @props.hideNotesForm

        onEditStart: =>
          @setState activeEditor: child.key
          
        onEditStop: =>
          @setState activeEditor: null

    if @props.onAttributeCreate?
      newForm = `<AttributeForm onCommit={ this.props.onAttributeCreate } inactive={ this.state.activeEditor != null } valueType={ this.props.valueType } onFocus={ this.clearEditor } />`

    className = 'attribute-table'

    if @props.sortable
      className += ' sortable'

    `<ul className={ className }>
        { children }
        { newForm }
    </ul>`
