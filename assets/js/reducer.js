export const reducer = (state, action) => {
  switch (action.type) {
    case 'scanned':
      return { status: 'scanned' };
    case 'processed':
      return { status: 'processed' };
    default:
      throw new Error();
  }
}
