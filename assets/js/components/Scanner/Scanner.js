import React, { useCallback, useReducer } from 'react'
import { useAsync, IfPending, IfFulfilled, IfRejected } from 'react-async'
import ConfirmationButton from "../ConfirmationButton/ConfirmationButton"
import QrReader from 'react-qr-reader'
import { fetchVisitor } from '../../api'
import { reducer } from '../../reducer'
import { initialState } from '../../state'

const Scanner = ({ eventId }) => {
  const [state, dispatch] = useReducer(reducer, initialState(eventId));

  const loadVisitor = useAsync({ deferFn: fetchVisitor })
  const setScannedStatus = (code) => dispatch({ type: 'scanned', payload: { code } })

  const handleScan = useCallback(
    (code) => code && loadVisitor.run(setScannedStatus, code)
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
            style={{ width: '100%' }}
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
                  <p class="title is-6 mt-6">Name des Gastes:</p>
                  <h2 class="title is-3 mb-6">{data.firstname} {data.lastname}</h2>

                  <p>&nbsp;</p>
                  <h2 class="title is-5 mt-4">Prüfe den Namen mit der ID</h2>
                  <div class="field is-grouped is-grouped-centered">
                    <p class="control">
                      <ConfirmationButton action="decline" state={state} dispatch={dispatch} />
                    </p>
                    <p class="control">
                      <ConfirmationButton action="confirm" state={state} dispatch={dispatch} />
                    </p>
                  </div>
                </>
                :
                <article className="message is-info">
                  <div className="message-body">
                    <strong>OK</strong>, du kannst jetzt den Code des nächsten Gastes scannen.
                  </div>
                </article>
              }
            </>
          }
        </IfFulfilled>
      </div>
    </>
  )
}

export default Scanner;
