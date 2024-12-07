import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input"]

  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submit(event)
    }
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
  }
} 