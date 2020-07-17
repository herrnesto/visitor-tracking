import React from "react";
import { render } from "react-dom";
import PhoneInput from "react-phone-input-2";
//import 'react-phone-input-2/lib/style.css'


class PhoneField extends React.Component {
  state = { phone: "" };

  handleOnChange = value => {
    this.setState({ phone: value }, () => {
      console.log(this.state.phone);
    });
  };

  render() {
    return (
      <div>
        <PhoneInput
          inputProps={{
            name: "profile[phone]",
            required: true,
            autoFocus: true,
          }}
          containerClass={"control"}
          inputClass={"input is-medium"}
          onlyCountries={['ch']}
          localization={{ch: 'Schweiz'}}
          country={"ch"}
          value={this.state.phone}
          onChange={this.handleOnChange}
          placeholder={"+41 79 000 00 00"}
        />
      </div>
    );
  }
}

export default PhoneField
