import React, { useState } from 'react'
import PhoneInput, { formatPhoneNumber, formatPhoneNumberIntl } from 'react-phone-number-input'
import 'react-phone-number-input/style.css'

const PhoneField = () => {
  const [value, setValue] = useState()

  return (
    <PhoneInput
      name="profile[phone]"
      defaultCountry="CH"
      country="CH"
      international
      class="input is-medium"
      placeholder="Enter phone number"
      value={value}
      onChange={setValue}
      error={value ? (isValidPhoneNumber(value) ? undefined : 'Invalid phone number') : 'Phone number required'}
      id="profile_phone"
    />
  )
}

export default PhoneField
