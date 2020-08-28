<template>
  <div>
    <div class="alert notification is-danger is-light" role="alert" v-if="isError">
      {{ api_error_message }}
    </div>

    <ValidationObserver ref="observer" v-slot="{ invalid }">

      <ValidationProvider rules="required|integer|min:6|max:6" name="code" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="text" v-model="code" size="is-medium" placeholder="Token"></b-input>
        </b-field>
      </ValidationProvider>

      <b-button size="is-medium"
                class="mt-5 is-fullwidth"
                type="is-primary"
                v-bind:loading="isSending"
                @click="submit"
                :disabled="invalid">
        Token prüfen
      </b-button>
    </ValidationObserver>
    <br />

    <b-loading :is-full-page="true" :active.sync="isSending" :can-cancel="true"></b-loading>

  </div>
</template>

<script>
import {ValidationObserver, ValidationProvider} from "vee-validate";
import axios from 'axios';

export default {
  components: {
    ValidationProvider,
    ValidationObserver
  },
  data() {
    return {
      api_url: "",
      next_step_url: "",
      create_path: "",
      isSending: false,
      isError: false,
      isInvalid: false,
      code: "",
      errors: [],
      api_error_message: ""
    }
  },
  methods: {
    submit() {
      this.isSending = true
      axios.post(this.api_url + this.create_path, {
        code: this.code
      })
          .then(response => {
            if (response.data.status == "error") {
              this.api_error_message = response.data.reason
              this.code = ""
              this.isError = true
              this.isSending = false
            } else {
              this.isSuccess = true
              window.location.href = this.api_url + this.next_step_url;
            }
          })
          .catch(e => {
            this.errors.push(e)
            this.isSending = false
          })
    },
  },
  created() {
    this.api_url = document.getElementById('api_url').value
    this.create_path = document.getElementById('create_path').value
    this.next_step_url = document.getElementById('next_step_url').value

    var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
    axios.defaults.headers['x-csrf-token'] = csrfToken;
    axios.defaults.headers['Accept'] = 'application/json';
    axios.defaults.headers['Content-Type'] = 'application/json';
  }
}
</script>