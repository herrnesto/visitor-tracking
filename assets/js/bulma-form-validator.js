/*!
 * jQuery plugin
 * What does it do
 */
(function ($) {
  $.fn.BulmaValidator = function (opts) {
    // default configuration
    var config = $.extend({}, {
      classes: {
        danger: "is-danger",
        success: "is-success",
        helptext: "help"
      },
      fields: ["input", "select"],
      settings: {
        text: {
          regex: "^[A-Za-z0-9_äÄöÖüÜß ,.'-]{3,35}$"
        },
        email: {
          regex: "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
        },
        select: {
          regex: "^[m|f]$"
        },
        tel: {
          regex: "^.{16,}$"
        },
        password: {
          regex: "^.{8,}$"
        }
      }
    }, opts);

    // main function
    function Validate(element) {
      switch (element.prop("tagName")) {
        case "SELECT":
          return ValidateSelect(element);
          break;
        default:
          return ValidateInput(element);
      }
    }

    function ValidateSelect(element) {
      var regex = new RegExp(config.settings["select"].regex);
      return ValidateCondition(regex.test(element.val()), element.parent());
    }

    function ValidateInput(element) {
      console.log(element.prop("type"))
      switch(element.prop("type")) {
        case "checkbox":
          var checkbox_validation = ($(".checkbox-agb:checked").length == 1) ? true : false;
          return ValidateCondition(checkbox_validation, element.parent());;
          break;
        case "password":
          var fieldtype = element.attr('type');
          var regex = new RegExp(config.settings[fieldtype].regex);
          return ValidateCondition(regex.test(element.val()), element);
          break;
        case "tel":
          var fieldtype = element.attr('type');
          var regex = new RegExp(config.settings[fieldtype].regex);
          return ValidateCondition(regex.test(element.val()), element);
          break;
        case "hidden":
          return true;
          break;
        default:
          var fieldtype = element.attr('type');
          var regex = new RegExp(config.settings[fieldtype].regex);
          return ValidateCondition(regex.test(element.val()), element);
      }
    }

    function ValidateCondition(validation, element){
      if (validation) {
        HighlightSuccess(element);
        return true;
      } else {
        HighlightError(element);
        return false;
      }
    }

    function HighlightSuccess(element) {
      element.removeClass(config.classes.danger)
        .addClass(config.classes.success)
        .data("validation-error", "false")
        .parent().siblings("." + config.classes.helptext).hide()

      RemoveIcon(element);
    }

    function HighlightError(element) {
      element.removeClass(config.classes.success)
        .addClass(config.classes.danger)
        .data("validation-error", "true")
        .parent().siblings("." + config.classes.helptext).show()

      AddIcon(element)
    }

    function ValidateAll($form) {
      validation = true;

      $form.find("input, select").each(function (index, element) {
        var $element = $(element);
        if ($.inArray($element.prop("tagName").toLowerCase(), config.fields) !== -1) {
          result = Validate($(element));
          validation = validation && result;
        }
      });

      console.log((validation) ? "Validation OK" : "Validation FAILED");
      return validation;
    }

    function RegisterValidator(e) {
      e.keyup(function () {
        Validate(e)
      });
    }

    function RegisterValidatorSelect(e) {
      e.change(function () {
        Validate(e)
      });
    }

    function AddIcon(e) {
      var html = '<span class="icon is-small is-right"><i class="fas fa-exclamation-triangle"></i></span>';

      if (e.parent().hasClass("has-icons-right")) {
        e.parent().append(html);
      }

    }

    function RemoveIcon(e) {
      e.siblings(".is-right").remove();
    }

    // initialize every element
    this.find("input").each(function () {
      RegisterValidator($(this));
    });

    // initialize every element
    this.find("select").each(function () {
      RegisterValidatorSelect($(this));
    });

    var $form = this;
    $form.find("[type=submit]").click(function (button) {
      button.preventDefault();
      $(button.target).addClass("is-loading");
      validation_state = ValidateAll($form)
      console.log(validation_state);

      if(validation_state) {
        // prevent fron infinite loop
        $(this).unbind('click');

        // Execute default action
        button.currentTarget.click();
      } else {
        $(button.target).removeClass("is-loading");
      }

    });

    return this;
  };
})(jQuery);
