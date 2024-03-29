// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "core-js/stable";
import "regenerator-runtime/runtime";
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

// render the QR-code scanner
const domContainer = document.querySelector("#scan")
if (domContainer) {
  const eventId = document.getElementById('event_id').value
  ReactDOM.render(<Scanner eventId={eventId} />, domContainer)
}

// responsive menu JS
document.addEventListener('DOMContentLoaded', () => {

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {

        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }
});



import Vue from "vue";
import PhoneInput from "./components/PhoneInput.vue";
import DatetimeInput from "./components/DatetimeInput.vue";
import EventScanner from "./components/EventScanner.vue";
import ContactForm from "./components/ContactForm.vue";
import RegistrationForm from "./components/RegistrationForm.vue";
import PasswordResetForm from "./components/PasswordResetForm.vue";
import TokenForm from "./components/TokenForm.vue";
import Buefy from 'buefy'
import "./vee-validate";

Vue.use(Buefy, {
  defaultIconPack: 'fa'
})

const phone_input_field = document.querySelector('#phone-input')
if (phone_input_field) {
  new Vue({
    render: h => h(PhoneInput)
  }).$mount("#phone-input")
}

const datetime_input_field = document.querySelector('#datetime-input')
if (datetime_input_field) {
  new Vue({
    render: h => h(DatetimeInput)
  }).$mount("#datetime-input")
}

const event_scanner_field = document.querySelector('#event-scanner')
if (event_scanner_field) {
  new Vue({
    render: h => h(EventScanner)
  }).$mount("#event-scanner")
}

const contact_form = document.querySelector('#contact-form')
if (contact_form) {
  new Vue({
    render: h => h(ContactForm)
  }).$mount("#contact-form")
}

const registration_form = document.querySelector('#vue-registration-form')
if (registration_form) {
  new Vue({
    render: h => h(RegistrationForm)
  }).$mount("#vue-registration-form")
}

const token_form = document.querySelector('#vue-token-form')
if (token_form) {
  new Vue({
    render: h => h(TokenForm)
  }).$mount("#vue-token-form")
}

const password_reset_form = document.querySelector('#vue-password-reset-form')
if (password_reset_form) {
  new Vue({
    render: h => h(PasswordResetForm)
  }).$mount("#vue-password-reset-form")
}
