<template>
  <div class="column">
    <h1 class="title is-4 mt-5">{{ event.name }}</h1>
    <p><strong>{{ visitors.total_visitors }} Besucher</strong></p>
    <b-progress :value="100 / event.visitor_limit * visitors.active_visitors"
                size="is-medium"
                type="is-info"
                show-value>
      <span style="color: black">Aktive: {{ visitors.active_visitors }} / {{ event.visitor_limit }}</span>
    </b-progress>

    <b-message title="Warnung!" type="is-warning" has-icon aria-close-label="Close message" :active.sync="warning.isActive">
      {{ warning.msg }}
    </b-message>

    <div v-if="visitor">
      <div v-if="visitor.checkin == 'out'">
        <b-message type="is-info">
          <h2 class="title is-3 mb-2">{{ visitor.firstname }} {{ visitor.lastname }}</h2>
          <span class="icon has-text-success" v-if="visitor.phone_verified"><i class="fas fa-check"></i></span>
          <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> Mobilnummer

          <br>
          <span class="icon has-text-success" v-if="visitor.email_verified"><i class="fas fa-check"></i></span>
          <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> E-Mail
        </b-message>

        <b-message type="is-warning">
          <h2 class="title is-5">Überprüfe die Daten mit der ID</h2>
        </b-message>

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
                      @click="checkin_visitor">
              Gast bestätigen
            </b-button>
          </p>
        </div>
      </div>
      <div v-else>
        <b-message type="is-info">
          <h2 class="title is-3 mb-2">{{ visitor.firstname }} {{ visitor.lastname }}</h2>
          <span class="icon has-text-success" v-if="visitor.phone_verified"><i class="fas fa-check"></i></span>
          <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> Mobilnummer

          <br>
          <span class="icon has-text-success" v-if="visitor.email_verified"><i class="fas fa-check"></i></span>
          <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> E-Mail
        </b-message>

        <b-message type="is-warning">
          <h2 class="title is-5">Gast wirklich abmelden?</h2>
        </b-message>

        <div class="field is-grouped is-grouped-centered">
          <p class="control">
            <b-button size="is-medium"
                      icon-left="ban"
                      type="is-danger"
                      @click="visitor = false">
              Abbrechen
            </b-button>
            <b-button size="is-medium"
                      icon-left="check"
                      type="is-success"
                      v-bind:loading="buttons.confirm.isLoading"
                      @click="checkout_visitor">
              Gast abmelden
            </b-button>
          </p>
        </div>
      </div>
    </div>
    <div v-else>
      <b-message type="is-info">
        Erfasse einen QR-Code mit deiner Kamera.
      </b-message>
      <p class="title is-6 mt-5"></p>
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
        event_id: null,
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
      request_event_data() {
        axios.post(this.api_url + `/scan/event_infos`,{event_id: this.event_id})
            .then(response => {
              this.visitors = response.data.visitors
              this.event = response.data.event
            })
            .catch(e => {
              this.errors.push(e)
            })
      },
      check_visitor: function () {
        axios.post(this.api_url + `/scan/user`, {uuid: this.uuid, event_id: this.event_id})
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
      checkin_visitor: function () {
        this.insert_action("in")
      },
      checkout_visitor: function () {
        this.insert_action("out")
      },
      insert_action(action){
        this.buttons.confirm.isLoading = true
        axios.post(this.api_url + `/scan/insert_action`, {
          event_id: this.event.id,
          uuid: this.uuid,
          action: action
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
    mounted() {
      this.$nextTick(function () {
        window.setInterval(() => {
          this.request_event_data()
        },5000);
      })
    },
    created() {
      this.api_url = document.getElementById('api_url').value
      this.event_id = document.getElementById('event_id').value

      var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
      axios.defaults.headers['x-csrf-token'] = csrfToken;
      axios.defaults.headers['Accept'] = 'application/json';
      axios.defaults.headers['Content-Type'] = 'application/json';

      this.request_event_data()
    }
  }
</script>