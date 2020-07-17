export const reducer = (state, action) => {
  switch (action.type) {
    case 'scanned':
      return {
        ...state,
        status: 'scanned',
        code: action.payload.code,
      };
    case 'processed':
      return {
        ...state,
        status: 'processed',
        code: null,
      };
    default:
      throw new Error();
  }
}
