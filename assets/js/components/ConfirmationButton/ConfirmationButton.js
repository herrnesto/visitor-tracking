import React, { useCallback } from 'react'
import { useAsync } from 'react-async'
import { confirmVisitor } from '../../api'

const ConfirmationButton = ({ action, state, dispatch }) => {
  let text, style, apiCall, handleClick
  const processVisitor = () => dispatch({ type: 'processed' })

  if (action === "confirm") {
    text = "Confirm visitor"
    style = "is-success"
    apiCall = useAsync({ deferFn: confirmVisitor })
    handleClick = useCallback(() => apiCall.run(processVisitor, state.code, state.eventId), [])
  } else {
    text = "Decline visitor"
    style = "is-danger"
    handleClick = useCallback(() => processVisitor())
  }

  return (
    <button className={`button ${style}`} onClick={handleClick}>
      {text}
    </button>
  )
}

export default ConfirmationButton;
