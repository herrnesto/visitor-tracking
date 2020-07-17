export const fetchVisitor = async ([setScannedStatus]) => {
  const response = await fetch('https://jsonplaceholder.typicode.com/todos/1')
  if (!response.ok) throw new Error(response.statusText)

  setScannedStatus();
  return response.json()
}

export const confirmVisitor = async ([processVisitor]) => {
  // Call the confirm endpoint
  console.log("confirmed")
  processVisitor();
}