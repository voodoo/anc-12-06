import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input", "submit"]

  connect() {
    this.validateInput()
  }

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submit(event)
    }
  }

  validateInput() {
    const content = this.inputTarget.value.trim()
    this.submitTarget.disabled = content === ""
  }

  submit(event) {
    event.preventDefault()
    const content = this.inputTarget.value.trim()
    if (content === "") return
    this.formTarget.requestSubmit()
  }

  reset() {
    this.inputTarget.value = ""
    this.inputTarget.style.height = 'auto'
    this.validateInput()
  }
} 