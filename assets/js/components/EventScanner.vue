<template>
  <div>
    <h1 class="title is-4">{{ event.name }}</h1>
    <p class="subtitle is-6">Besucher: {{ visitors }}</p>

    <b-message title="Warnung!" type="is-warning" has-icon aria-close-label="Close message" :active.sync="warning.isActive">
      {{ warning.msg }}
    </b-message>

    <div v-if="visitor">
      <h2 class="title is-3 mb-6">{{ visitor.firstname }} {{ visitor.lastname }}</h2>
      <h2 class="title is-5 mt-4">Prüfe den Namen mit der ID</h2>

      <div class="content">
        <span class="icon has-text-success" v-if="visitor.phone_verified"><i class="fas fa-check"></i></span>
        <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> Mobilnummer

        <br>
        <span class="icon has-text-success" v-if="visitor.email_verified"><i class="fas fa-check"></i></span>
        <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> E-Mail
      </div>
      <div class="field is-grouped is-grouped-centered">
        <p class="control">
          <b-button size="is-medium"
                    icon-left="ban"
                    type="is-danger"
                    @click="visitor = false">
            Ablehnen
          </b-button>
          <b-button size="is-medium"
                    icon-left="check"
                    type="is-success"
                    v-bind:loading="buttons.confirm.isLoading"
                    @click="confirm_visitor">
            Gast bestätigen
          </b-button>
        </p>
      </div>
    </div>
    <div v-else>
      <p class="title is-6 mt-6">Halte die Kamera vor einen QR-Code:</p>
      <qrcode-stream @detect="onDetect" @init="onInit"></qrcode-stream>
    </div>

    <b-loading :is-full-page="true" :active.sync="scanner.isLoading" :can-cancel="true"></b-loading>

  </div>
</template>

<script>
  import { QrcodeStream, QrcodeDropZone, QrcodeCapture } from 'vue-qrcode-reader'
  import axios from 'axios';

  export default {

    components: {
      QrcodeStream,
      QrcodeDropZone,
      QrcodeCapture
    },
    data() {
      return {
        api_url: null,
        event: { name: ""},
        visitors: 0,
        visitor: false,
        uuid: null,
        scanner: {
          isLoading: false
        },
        buttons: {
          confirm: {
            isLoading: false
          }
        },
        warning: {
          isActive: false,
          msg: ""
        }
      }
    },
    methods: {
      show_warning(msg) {
        this.warning.isActive = true
        this.warning.msg = msg
      },
      toast(type, msg) {
        this.$buefy.toast.open({
          duration: 5000,
          message: msg,
          position: 'is-bottom',
          type: type
        })
      },
      check_visitor: function () {
        axios.post(this.api_url + `/scan/user`, {uuid: this.uuid})
          .then(response => {
            if(response.data.status == "error"){
              this.toast("is-danger", "Ungültiger QR Code!")
            } else {
              this.visitor = response.data
            }
          })
          .catch(e => {
            this.errors.push(e)
          })
      },
      confirm_visitor: function () {
        this.buttons.confirm.isLoading = true
        axios.post(this.api_url + `/scan/assign_visitor`, {
            event_id: this.event.id,
            uuid: this.uuid
          })
          .then(response => {
            this.visitor = false
            this.buttons.confirm.isLoading = false
            this.toast("is-success", "Besucher wurde registiert.")
          })
          .catch(e => {
            this.errors.push(e)
            this.buttons.confirm.isLoading = false
            this.toast("is-danger", "Fehler beim Registrieren.")
          })

      },
      async onDetect(promise) {
        try {
          const {
            imageData,    // raw image data of image/frame
            content,      // decoded String
            location      // QR code coordinates
          } = await promise

          if (content === null) {
            // decoded nothing
          } else {
            this.uuid = content
            this.check_visitor()
          }
        } catch (error) {
          // ...
        }
      },
      async onInit(promise) {
        this.scanner.isLoading = true

        try {
          const {capabilities} = await promise

        } catch (error) {
          if (error.name === 'NotAllowedError') {
            // user denied camera access permisson
            this.show_warning("Du musst uns die Berechtigung zur Nutzung deiner Kamera geben.")
          } else if (error.name === 'NotFoundError') {
            // no suitable camera device installed
            this.show_warning("Leider funtkioniert die Kamera deines Smartphones nicht.")
          } else if (error.name === 'NotSupportedError') {
            // page is not served over HTTPS (or localhost)
            this.show_warning("Die Verbindung funktioniert nur über HTTpS>.")
          } else if (error.name === 'NotReadableError') {
            // maybe camera is already in use
            this.show_warning("Wir können deine Kamera nicht ansprechen. Wird sie gerade verwendet?")
          } else if (error.name === 'OverconstrainedError') {
            // did you requested the front camera although there is none?
            this.show_warning("Willst du die Frontkamera verwenden, obwohl du keine hast?")
          } else if (error.name === 'StreamApiNotSupportedError') {
            // browser seems to be lacking features
            this.show_warning("Dieser Browser ist nicht kompatibel. Versuche es mit der neusten Version von Safari oder Chrome.")
          }
        } finally {
          this.scanner.isLoading = false
        }
      },
    },
    created() {
      this.api_url = document.getElementById('api_url').value

      var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
      axios.defaults.headers['x-csrf-token'] = csrfToken;

      axios.post(this.api_url + `/scan/event_infos`,{id: 1})
        .then(response => {
          this.visitors = response.data.visitors
          this.event = response.data.event
        })
        .catch(e => {
          this.errors.push(e)
        })
    }
  }
</script>