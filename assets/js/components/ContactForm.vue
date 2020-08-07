<template>
  <section>
    <div v-if="isSuccess">
      <div class="content is-medium">
        <h1 class="title">Hallo {{ name }}! Danke für deine Nachricht!</h1>
        <p>Unsere Mailbox kann es kaum erwarten deine Nachrichten zu erhalten. Also schreibe uns wann immer du möchtest!</p>
        <p>Cheers!</p>
      </div>
    </div>
    <div v-else>
      <h1 class="title">Schreibe uns irgendwas!</h1>

      <div class="mb-5" v-if="isError">
        <b-notification
            type="is-warning"
            has-icon
            role="alert">
          Ein unbekannter Fehler ist aufgetreten. Du erreichst uns unter hello@vesita.ch
        </b-notification>
      </div>

      <form action="">
        <b-field>
          <b-input placeholder="Name"
                   type="text"
                   min="10"
                   max="50"
                   size="is-medium"
                   required
                   v-model="name">
          </b-input>
        </b-field>

        <b-field>
          <b-input placeholder="Email"
                   type="email"
                   size="is-medium"
                   required
                   v-model="email">

          </b-input>
        </b-field>

        <b-field>
          <b-input type="textarea"
                   minlength="10"
                   maxlength="1000"
                   placeholder="Nachricht"
                   size="is-medium"
                   required
                   v-model="message">
          </b-input>
        </b-field>

        <div class="field is-grouped is-grouped-centered">
          <div class="control">
            <b-button size="is-medium"
                      native-type="submit"
                      type="is-primary"
                      v-bind:loading="isSending"
                      @click="send_message">Nachricht senden
            </b-button>
          </div>
        </div>
      </form>
    </div>
  </section>
</template>

<script>
import { VueTelInput } from 'vue-tel-input'
import axios from 'axios';

export default {
  components: {
    VueTelInput
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
    send_message () {
      this.isSending = true
      axios.post(this.api_url + this.create_path, {contact_form: {name: this.name, email: this.email, message: this.message }})
          .then(response => {
            if(response.data.status == "error"){
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
