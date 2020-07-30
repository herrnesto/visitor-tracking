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
import Scanner from "./components/Scanner/Scanner"
import PhoneField from "./components/PhoneField/PhoneField"
import SessionPhoneField from "./components/PhoneField/SessionPhoneField"
import React from "react"
import ReactDOM from "react-dom"
import "./bulma-form-validator"

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

// render the phone number input
const phoneDomField = document.querySelector('#phone_field')
if (phoneDomField) {
  ReactDOM.render(<PhoneField />, phoneDomField)
}
const sessionPhoneDomField = document.querySelector('#session_phone_field')
if (sessionPhoneDomField) {
  ReactDOM.render(<SessionPhoneField />, sessionPhoneDomField)
}

$(function() {
  $("#registration-form").BulmaValidator({
    name: "BulmaValidator",
    callback: "submitMemberForm"
  });
});

function submitMemberForm() {
  //grecaptcha.ready(function () {
    //grecaptcha.execute('6LedtPoUAAAAANKERJZ7sIdFypoH-Zygx5YdaU8S', {action: 'submit'}).then(function (token) {
      var ajaxurl = $(location).attr("href");
      var data =  {
        'action': 'send_member_form',
        '_ajax_nonce': sleepless_globals.nonce,
        'form_data': $('#member-form').serialize()
      };

      $.ajax({
        type : 'post',
        dataType : 'json',
        url : sleepless_globals.ajax_url,
        data : data,
        success: function( response ) {
          console.log(response);
          if( response.status == 201 ) {
            window.location.href = window.location.origin + "/phone_verification";
          }
          else {
            alert( 'Something went wrong, try again!' );
          }
        }
      })
    //});
  //});
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