import { required, alpha_spaces, min, max, email } from "vee-validate/dist/rules";
import { extend } from "vee-validate";

extend("required", {
  ...required,
  message: "Das ist ein Pflichtfeld!"
});

extend("email", {
  ...email,
  message: "Wir brauchen eine gültige E-Mail-Adresse um dir zu antworten."
});

extend("alpha_spaces", {
  ...alpha_spaces,
  message: "Nutze alphanumerische Zeichen."
});

extend("min", {
  ...min,
  message: "Minimum 15 Zeichen."
});

extend("max", {
  ...max,
  message: "Maximale Anzahl Zeichen erreicht."
});
