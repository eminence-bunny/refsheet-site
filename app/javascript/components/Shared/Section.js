/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
*/
import React from 'react'
import PropTypes from 'prop-types'
import {Row, Col} from 'react-materialize'
import {Sticky, StickyContainer} from 'react-sticky'
import c from 'classnames'
import EditableHeader from 'Shared/EditableHeader'
import styled from 'styled-components'

const H2 = styled.h2`
  color: ${props => props.theme.primary};
  line-height: 48px;
  margin: 0;
`

const Button = styled.a`
  background-color: ${props => props.theme.cardBackground} !important;
  display: inline-block;
  margin: 6px 0 6px 1.5rem;
  float: right;
`

const SectionTitle = styled.div`
  background-color: ${props => props.theme.background};
`

const Section = function ({id, className, titleClassName, title, tabs, container, onTabClick, buttons, children, editable, onTitleChange}) {
  const renderTitle = function ({style, isSticky}) {
    let titleStyle;
    if (isSticky) {
      style = {
        ...style,
        zIndex: '990'
      };

      titleStyle = {
        paddingTop: '0.5rem',
        paddingBottom: '0.5rem'
      };
    }

    return <div className={c(titleClassName, {container})} style={{...style, top: '56px'}}>
      <SectionTitle className='row no-margin' style={titleStyle}>
        <Col m={4}>
          <EditableHeader component={H2} editable={editable} onValueChange={onTitleChange}>{title}</EditableHeader>
        </Col>

        <Col m={8} className='right-align'>
          {buttons && buttons.map(renderAction)}

          {tabs &&
          <ul className='tabs transparent right' style={{display: 'inline-block', width: 'auto'}}>
            {tabs.map(renderTab(onTabClick))}
          </ul>}
        </Col>
      </SectionTitle>
    </div>
  }

  return <StickyContainer>
    <section id={id} className={c(className, {container})}>
      {title && <Sticky topOffset={-66}>{renderTitle}</Sticky>}

      <div className={c({container})}>
        {children}
      </div>
    </section>
  </StickyContainer>
}


const actionHandler = (onClick, id) => function (e) {
  e.preventDefault();
  if (onClick) {
    return onClick(id);
  }
}

var renderTab = onTabClick => function ({title, id, onClick}) {
  if (!onClick) {
    onClick = onTabClick;
  }

  return <li className="tab" key={id}>
    <a href={`#${id}`} onClick={actionHandler(onClick, id)}>{title}</a>
  </li>;
};

var renderAction = ({title, id, onClick, icon}) =>
  <Button className='btn' onClick={actionHandler(onClick, id)}>
    {icon && <Icon className='left'>{icon}</Icon>}
    {title}
  </Button>
;


const actionType =
  PropTypes.shape({
    icon: PropTypes.string,
    title: PropTypes.string.isRequired,
    id: PropTypes.string,
    onClick: PropTypes.func
  });

Section.propTypes = {
  id: PropTypes.string,
  children: PropTypes.node.isRequired,
  title: PropTypes.string,
  tabs: PropTypes.arrayOf(actionType),
  buttons: PropTypes.arrayOf(actionType),
  onTabClick: PropTypes.func,
  onButtonClick: PropTypes.func,
  container: PropTypes.bool,
  className: PropTypes.string,
  titleClassName: PropTypes.string,
  editable: PropTypes.boolean,
  onTitleChange: PropTypes.func
};

export default Section;
