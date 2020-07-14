import React, { useCallback, useState } from 'react'
import QrReader from 'react-qr-reader'

const Scanner = () => {
  const [result, setResult] = useState(null);
  const handleScan = useCallback(
    (data) => {
      if (data) {
        setResult(data);
      }
    },
    []
  )

  const handleError = useCallback(
    (data) => {
      console.log(data)
    },
    []
  )

  return (
    <div>
      <QrReader
        delay={300}
        onError={handleError}
        onScan={handleScan}
        style={{ width: '300px', height: '300px' }}
      />
      <p>{result}</p>
    </div>
  )
}

export default Scanner;
