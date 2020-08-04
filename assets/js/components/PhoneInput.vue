<template>
      <vue-tel-input v-model="phone" v-bind="bindProps" class="control"></vue-tel-input>
</template>

<script>
  import { VueTelInput } from 'vue-tel-input'

  export default {
    components: {
      VueTelInput
    },
    data() {
      return {
        phone: "",
        bindProps: {
          mode: "international",
          defaultCountry: "CH",
          disabledFetchingCountry: false,
          disabled: false,
          disabledFormatting: false,
          placeholder: "Mobilnummer eingeben",
          required: true,
          enabledCountryCode: false,
          enabledFlags: true,
          preferredCountries: ["CH"],
          onlyCountries: [],
          ignoredCountries: [],
          autocomplete: "off",
          name: "phone",
          maxLen: 25,
          wrapperClasses: "",
          inputClasses: "input is-medium",
          dropdownOptions: {
            disabledDialCode: false
          },
          inputOptions: {
            showDialCode: false
          }
        }
      }
    },
    created() {
      console.log("Vue component created")
    }
  }
</script>
