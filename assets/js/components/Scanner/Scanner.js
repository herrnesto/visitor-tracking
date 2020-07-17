import React, { useCallback, useReducer } from 'react'
import { useAsync, IfPending, IfFulfilled, IfRejected } from 'react-async'
import ConfirmationButton from "../ConfirmationButton/ConfirmationButton"
import QrReader from 'react-qr-reader'
import { fetchVisitor } from '../../api'
import { reducer } from '../../reducer'
import { initialState } from '../../state'

const Scanner = () => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const loadVisitor = useAsync({ deferFn: fetchVisitor })
  const setScannedStatus = () => dispatch({ type: 'scanned' })

  const handleScan = useCallback(
    (code) => code && loadVisitor.run(setScannedStatus)
  )
  const handleError = useCallback(
    () => console.log("This QR code cannot be read."), []
  )

  return (
    <>
      {state.status !== 'scanned' &&
        <div>
          <QrReader
            delay={1000}
            onError={handleError}
            onScan={handleScan}
            style={{ width: '300px', height: '300px' }}
          />
        </div>
      }

      <div className="box">
        <IfPending state={loadVisitor}>Loading...</IfPending>
        <IfRejected state={loadVisitor}>Error fetching the visitor for this QR code.</IfRejected>
        <IfFulfilled state={loadVisitor}>
          {data =>
            <>
              {state.status === 'scanned' ?
                <>
                  <p>This QR code belongs to:</p>
                  <strong>{data.title}</strong>
                  <p>Check this visitor ID and confirm or decline.</p>

                  <div>
                    <ConfirmationButton action="decline" dispatch={dispatch} />
                    <ConfirmationButton action="confirm" dispatch={dispatch} />
                  </div>
                </>
                :
                <div>
                  <p>Done! Scan a new visitor</p>
                </div>
              }
            </>
          }
        </IfFulfilled>
      </div>
    </>
  )
}

export default Scanner;
