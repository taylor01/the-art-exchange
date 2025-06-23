import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-method"
export default class extends Controller {
  static targets = ["passwordField"]
  static values = { method: String }

  connect() {
    this.togglePasswordField()
  }

  methodChanged() {
    this.togglePasswordField()
  }

  togglePasswordField() {
    const passwordRadio = this.element.querySelector('#login_method_password')
    
    if (passwordRadio && passwordRadio.checked) {
      this.passwordFieldTarget.classList.remove('hidden')
    } else {
      this.passwordFieldTarget.classList.add('hidden')
    }
  }
}