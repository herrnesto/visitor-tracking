import { required, alpha_spaces, integer, email } from "vee-validate/dist/rules";
import { extend } from "vee-validate";

extend("required", {
  ...required,
  message: "Das ist ein Pflichtfeld!"
});

extend("integer", {
  ...integer,
  message: "Nur Zahlen erlaubt."
});

extend("email", {
  ...email,
  message: "Wir brauchen eine gültige E-Mail-Adresse um dir zu antworten."
});

extend("alpha_spaces", {
  ...alpha_spaces,
  message: "Nutze alphanumerische Zeichen."
});


extend('min', {
  validate(value, { length }) {
    return value.length >= length;
  },
  params: ['length'],
  message: 'Die Eingabe muss aus mindestens {length} Zeichen bestehen.'
});

extend('max', {
  validate(value, { length }) {
    return value.length <= length;
  },
  params: ['length'],
  message: 'Die Eingabe darf aus maximal {length} Zeichen bestehen.'
});

extend('password', {
  params: ['target'],
  validate(value, { target }) {
    return value === target;
  },
  message: 'Beide Passwörter müssen übereinstimmen.'
});