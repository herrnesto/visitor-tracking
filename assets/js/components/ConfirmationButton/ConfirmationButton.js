import React, { useCallback } from 'react'
import { useAsync, IfPending, IfFulfilled, IfRejected } from 'react-async'

const confirmVisitor = async ([processVisitor]) => {
  // Call the confirm endpoint
  console.log("confirmed")
  processVisitor();
}
const declineVisitor = async ([processVisitor]) => {
  // Call the decline endpoint
  console.log("declined")
  processVisitor();
}

const ConfirmationButton = ({ action, dispatch }) => {
  let text, style, callback
  const processVisitor = () => dispatch({ type: 'processed' })

  if (action === "confirm") {
    text = "Confirm visitor"
    style = "is-success"
    callback = useAsync({ deferFn: confirmVisitor })
  } else {
    text = "Decline visitor"
    style = "is-danger"
    callback = useAsync({ deferFn: declineVisitor })
  }
  const handleClick = useCallback(() => callback.run(processVisitor), [])

  return (
    <button className={`button ${style}`} onClick={handleClick}>
      {text}
    </button>
  )
}

export default ConfirmationButton;
