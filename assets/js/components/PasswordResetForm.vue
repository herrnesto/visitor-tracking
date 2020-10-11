<template>
  <div>
    <div class="mb-5" v-if="isError">
      <b-notification
          type="is-warning"
          has-icon
          role="alert">
        Ein unbekannter Fehler ist aufgetreten. Du erreichst uns unter hello@vesita.ch
      </b-notification>
    </div>

    <ValidationObserver ref="observer" v-slot="{ invalid }">

      <ValidationProvider rules="required|min:8|password:@password_confirmation" name="password" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="password" v-model="password" size="is-medium" placeholder="Passwort"></b-input>
        </b-field>
      </ValidationProvider>

      <ValidationProvider rules="required|min:8" name="password_confirmation" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="password" v-model="password_confirmation" size="is-medium" placeholder="Passwort bestätigen"></b-input>
        </b-field>
      </ValidationProvider>

      <div class="notification is-warning is-light mt-5" v-if="invalid">
        Mindestens eine Eingabe fehlt oder ist falsch.
      </div>

      <b-button size="is-medium"
                class="mt-5 is-fullwidth"
                type="is-primary"
                v-bind:loading="isSending"
                @click="submit"
                :disabled="invalid">
        Passwort ändern
      </b-button>
    </ValidationObserver>

    <b-loading :is-full-page="true" :active.sync="isSending" :can-cancel="true"></b-loading>

  </div>
</template>

<script>
import {ValidationObserver, ValidationProvider} from "vee-validate";
import axios from 'axios';

export default {
  name: "PasswordResetForm",
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
      token: "",
      password: "",
      password_confirmation: "",
      errors: []
    }
  },
  methods: {
    submit() {
      this.isSending = true
      axios.post(this.api_url + this.create_path, {
        token: this.token,
        user: {
          password: this.password,
          password_confirmation: this.password_confirmation,
        }
      })
      .then(response => {
        if (response.data.status == "error") {
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
    this.token = document.getElementById('token').value
    this.next_step_url = document.getElementById('next_step_url').value

    var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
    axios.defaults.headers['x-csrf-token'] = csrfToken;
    axios.defaults.headers['Accept'] = 'application/json';
    axios.defaults.headers['Content-Type'] = 'application/json';
  }
}
</script>