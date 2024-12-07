import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { timeout: Number }

  connect() {
    if (this.timeoutValue > 0) {
      setTimeout(() => {
        this.dismiss()
      }, this.timeoutValue)
    }
  }

  dismiss() {
    this.messageTargets.forEach(message => {
      message.classList.add('opacity-0', '-translate-y-2')
      setTimeout(() => {
        message.remove()
      }, 500)
    })
  }
} 