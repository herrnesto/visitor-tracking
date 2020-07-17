import React, { useCallback } from 'react'
import { useAsync } from 'react-async'
import { confirmVisitor } from '../../api'

const ConfirmationButton = ({ action, state, dispatch }) => {
  let text, style, icon, apiCall, handleClick
  const processVisitor = () => dispatch({ type: 'processed' })

  if (action === "confirm") {
    text = "Gast bestätigen"
    style = "is-success"
    icon = "fa-check"
    apiCall = useAsync({ deferFn: confirmVisitor })
    handleClick = useCallback(() => apiCall.run(processVisitor, state.code, state.eventId), [])
  } else {
    text = "Ablehnen"
    style = "is-danger"
    icon = "fa-ban"
    handleClick = useCallback(() => processVisitor())
  }

  return (
    <button className={`button is-medium ${style}`} onClick={handleClick}>
      <span class={`icon is-small`}>
        <i class={`fas ${icon}`}></i>
      </span>
      <span>
        {text}
      </span>
    </button>
  )
}

export default ConfirmationButton;