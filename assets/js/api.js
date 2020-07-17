export const fetchVisitor = async ([setScannedStatus, code]) => {
  const response = await fetch(`/api/scan/user?uuid=${code}`, {
    method: "POST",
  })
  if (!response.ok) throw new Error(response.statusText)

  setScannedStatus(code);
  return response.json()
}

export const confirmVisitor = async ([processVisitor, code, eventId]) => {
  const response = await fetch(`/api/scan/assign_visitor?uuid=${code}&event_id=${eventId}`,
    { method: "POST" })

  if (!response.ok) throw new Error(response.statusText)

  processVisitor();
}