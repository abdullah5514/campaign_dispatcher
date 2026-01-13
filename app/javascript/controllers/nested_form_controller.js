import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "item"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.element.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest('[data-nested-form-target="item"]')
    
    if (item.dataset.newRecord === "true") {
      item.remove()
    } else {
      item.style.display = "none"
      const destroyInput = item.querySelector('input[name*="_destroy"]')
      if (destroyInput) {
        destroyInput.value = "1"
      }
    }
  }
}

