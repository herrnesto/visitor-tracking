import React, { useCallback } from 'react'
import { useAsync, IfPending, IfFulfilled, IfRejected } from 'react-async'
import { confirmVisitor, declineVisitor } from '../../api'

const ConfirmationButton = ({ action, dispatch }) => {
  let text, style, apiCall, handleClick
  const processVisitor = () => dispatch({ type: 'processed' })

  if (action === "confirm") {
    text = "Confirm visitor"
    style = "is-success"
    apiCall = useAsync({ deferFn: confirmVisitor })
    handleClick = useCallback(() => apiCall.run(processVisitor), [])
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
