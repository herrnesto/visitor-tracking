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

      <p class="title is-4">Personalien</p>

      <ValidationProvider rules="required|alpha_spaces|max:50" name="firstname" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="text" v-model="firstname" size="is-medium" placeholder="Vorname"></b-input>
        </b-field>
      </ValidationProvider>

      <ValidationProvider rules="required|alpha_spaces|max:50" name="lastname" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="text" v-model="lastname" size="is-medium" placeholder="Nachname"></b-input>
        </b-field>
      </ValidationProvider>

      <ValidationProvider rules="required|integer|min:4|max:10" name="zip" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="text" v-model="zip" size="is-medium" placeholder="Postleitzahl"></b-input>
        </b-field>
      </ValidationProvider>

      <ValidationProvider rules="required|alpha_spaces|max:50" name="city" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="text" v-model="city" size="is-medium" placeholder="Wohnort"></b-input>
        </b-field>
      </ValidationProvider>

      <ValidationProvider rules="required|email" name="Email" v-slot="{ errors, valid }">
        <b-field
            :type="{ 'is-danger': errors[0], 'is-success': valid }"
            :message="errors">
          <b-input type="email" v-model="email" size="is-medium" placeholder="E-Mail"></b-input>
        </b-field>
      </ValidationProvider>

      <p class="title is-4 mt-5">Sicherheit</p>
      <p class="subtitle is-6">Setze ein Passwort um jederzeit die Kontrolle über deine Daten zu haben.</p>

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

      <div class="notification is-danger is-light mt-5" v-if="invalid">
        Mindestens eine Eingabe fehlt oder ist falsch.
      </div>

      <b-button size="is-medium"
                class="mt-5 is-fullwidth"
                type="is-primary"
                v-bind:loading="isSending"
                @click="submit"
                :disabled="invalid">
        Kostenlos Registrieren
      </b-button>
    </ValidationObserver>
    <br />
    <small>
      <em>
        Mit dem Registrieren stimmst du unseren <a href="/datenschutz">Datenschutzrichtlinien</a> zu.
      </em>
    </small>
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
      phone: "",
      isSending: false,
      isError: false,
      isInvalid: false,
      firstname: "",
      lastname: "",
      zip: "",
      city: "",
      email: "",
      password: "",
      password_confirmation: "",
      errors: []
    }
  },
  methods: {
    submit() {
      this.isSending = true
      axios.post(this.api_url + this.create_path, {
        user: {
          firstname: this.firstname,
          lastname: this.lastname,
          zip: this.zip,
          city: this.city,
          phone: this.phone,
          email: this.email,
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
    this.phone = document.getElementById('phone').value
    this.next_step_url = document.getElementById('next_step_url').value

    var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
    axios.defaults.headers['x-csrf-token'] = csrfToken;
    axios.defaults.headers['Accept'] = 'application/json';
    axios.defaults.headers['Content-Type'] = 'application/json';
  }
}
</script>