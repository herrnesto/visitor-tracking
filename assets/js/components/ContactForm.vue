<template>
  <section>

    <div v-if="isSuccess">
      <div class="content is-medium">
        <h1 class="title">Hallo {{ name }}! Danke für deine Nachricht!</h1>
        <p>Unsere Mailbox kann es kaum erwarten deine Nachrichten zu erhalten. Also schreibe uns wann immer du
          möchtest!</p>
        <p>Cheers!</p>
      </div>
    </div>

    <div v-else>
      <h1 class="title">Wir freuen uns über einen Gruss von dir!</h1>

      <div class="mb-5" v-if="isError">
        <b-notification
            type="is-warning"
            has-icon
            role="alert">
          Ein unbekannter Fehler ist aufgetreten. Du erreichst uns unter hello@vesita.ch
        </b-notification>
      </div>

        <ValidationObserver ref="observer" v-slot="{ handleSubmit }">
          <!-- the "handleSubmit" function on the slot-scope executes the callback if validation was successfull -->
          <ValidationProvider rules="required|email" name="Email" v-slot="{ errors, valid }">
            <b-field
                label="Deine E-Mail-Adresse"
                :type="{ 'is-danger': errors[0], 'is-success': valid }"
                :message="errors">
              <b-input type="email" v-model="email" size="is-medium"></b-input>
            </b-field>
          </ValidationProvider>

          <ValidationProvider rules="required|alpha_spaces|max:50" name="name" v-slot="{ errors, valid }">
            <b-field
                label="Name"
                :type="{ 'is-danger': errors[0], 'is-success': valid }"
                :message="errors">
              <b-input type="text" v-model="name" size="is-medium"></b-input>
            </b-field>
          </ValidationProvider>

          <ValidationProvider rules="required|min:15|max:1000" name="message" v-slot="{ errors, valid }">
            <b-field
                label="Nachricht"
                :type="{ 'is-danger': errors[0], 'is-success': valid }"
                :message="errors">
              <b-input type="textarea" v-model="message" size="is-medium"></b-input>
            </b-field>
          </ValidationProvider>

          <b-button size="is-medium"
                    class="mt-5"
                    icon-left="paper-plane"
                    type="is-primary"
                    v-bind:loading="isSending"
                    @click="handleSubmit(executeRecaptcha)">
            Abschicken
          </b-button>
        </ValidationObserver>
        <vue-recaptcha sitekey="6Ldhsr8ZAAAAAKZys6Z4jZf3dM-Vtw2FCj5hIXwr"
                       ref="invisibleRecaptcha"
                       @verify="onVerify"
                       @expired="onExpired"
                       size="invisible"
                       :loadRecaptchaScript="true">
        </vue-recaptcha>

    </div>
  </section>
</template>


<script>
import {ValidationObserver, ValidationProvider} from "vee-validate";
import axios from 'axios';
import VueRecaptcha from 'vue-recaptcha';

export default {
  name: "ContactForm",
  components: {
    ValidationProvider,
    ValidationObserver,
    VueRecaptcha
  },
  data() {
    return {
      api_url: "",
      create_path: "",
      isSending: false,
      isSuccess: false,
      isError: false,
      name: "",
      email: "",
      message: "",
      errors: []
    }
  },
  methods: {
    send_message() {
      axios.post(this.api_url + this.create_path, {
        contact_form: {
          name: this.name,
          email: this.email,
          message: this.message
        }
      })
      .then(response => {
        if (response.data.status == "error") {
          this.isError = true
        } else {
          this.isSuccess = true
        }
        this.isSending = false
      })
      .catch(e => {
        this.errors.push(e)
        this.isSending = false
      })
    },
    executeRecaptcha () {
      this.$refs.invisibleRecaptcha.execute()
    },
    onVerify: function (response) {
      console.log('Verify: ' + response)
      this.isSending =  true
      this.send_message()
    },
    onExpired: function () {
      console.log('Expired')
    },
  },
  created() {
    this.api_url = document.getElementById('api_url').value
    this.create_path = document.getElementById('create_path').value

    var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
    axios.defaults.headers['x-csrf-token'] = csrfToken;
    axios.defaults.headers['Accept'] = 'application/json';
    axios.defaults.headers['Content-Type'] = 'application/json';
  }
}
</script>
